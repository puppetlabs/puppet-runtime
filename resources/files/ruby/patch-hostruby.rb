# When cross compiling we need to run gem install using the host ruby, but
# force ruby to use our overridden rbconfig.rb. To do that, we insert a
# require statement between the ruby executable and it's first argument,
# thereby hooking the ruby process.
#
# In the future we could use the --target-rbconfig=<path> option to point
# to our rbconfig.rb. But that option is only available in newer ruby versions.
require 'rbconfig'
require 'tempfile'

if ARGV.length < 2
  warn <<USAGE
USAGE: patch-hostruby.rb <target_ruby_version> <target_triple>

example: patch-hostruby.rb 3.2.2 arm64-darwin
USAGE
  exit(1)
end

# target ruby versions (what we're trying to build)
target_ruby_version = ARGV[0]
target_triple = ARGV[1]
target_api_version = target_ruby_version.gsub(/\.\d*$/, '.0')

# host ruby (the ruby we execute to build the target)
host_rubylibdir = RbConfig::CONFIG['rubylibdir']
GEM_VERSION = Gem::Version.new(Gem::VERSION)

# Rewrite the file in-place securely, yielding each line to the caller
def rewrite(file)
  # create temp file in the same directory as the file we're patching,
  # so rename doesn't cross filesystems
  tmpfile = Tempfile.new(File.basename(file), File.dirname(file))
  begin
    File.open("#{file}.orig", "w") do |orig|
      File.open(file, 'r').readlines.each do |line|
        orig.write(line)
        yield line
        tmpfile.write(line)
      end
    end
  ensure
    tmpfile.close
    File.unlink(file)
    File.rename(tmpfile.path, file)
    tmpfile.unlink
  end
end

# Based on the RUBYGEMS version of the host ruby, the line and file that needs patching is different
# Note the RUBY version doesn't matter (for either the host or target ruby).
#
# Here we define different intervals. For each interval, we specify the regexp to match, what to
# replace it with, and which file to edit in-place. Note `\&` is a placeholder for whatever the regexp
# was, that way we can easily append to it. And since it's in a double quoted string, it's escaped
# as `\\&`
#
if GEM_VERSION <= Gem::Version.new('2.0.0')
  # $ git show v2.0.0:lib/rubygems/ext/ext_conf_builder.rb
  #   cmd = "#{Gem.ruby} #{File.basename extension}"
  regexp  = /{Gem\.ruby}/
  replace = "\\& -r/opt/puppetlabs/puppet/share/doc/rbconfig-#{target_ruby_version}-orig.rb"
  builder = 'rubygems/ext/ext_conf_builder.rb'
elsif GEM_VERSION < Gem::Version.new('3.0.0') # there weren't any tags between >= 2.7.11 and < 3.0.0
  # $ git show v2.0.1:lib/rubygems/ext/ext_conf_builder.rb
  #   cmd = [Gem.ruby, File.basename(extension), *args].join ' '
  #
  # $ git show v2.7.11:lib/rubygems/ext/ext_conf_builder.rb
  #   cmd = [Gem.ruby, "-r", get_relative_path(siteconf.path), File.basename(extension), *args].join ' '
  regexp  = /Gem\.ruby/
  replace = "\\&, '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{target_ruby_version}-orig.rb'"
  builder = 'rubygems/ext/ext_conf_builder.rb'
elsif GEM_VERSION <= Gem::Version.new('3.4.8')
  # $ git show v3.0.0:lib/rubygems/ext/ext_conf_builder.rb
  #   cmd = Gem.ruby.shellsplit << "-I" << File.expand_path("../../..", __FILE__) <<
  #
  # $ git show v3.4.8:lib/rubygems/ext/ext_conf_builder.rb
  #   cmd = Gem.ruby.shellsplit << "-I" << File.expand_path("../..", __dir__) << File.basename(extension)
  regexp  = /Gem\.ruby\.shellsplit/
  replace = "\\& << '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{target_ruby_version}-orig.rb'"
  builder = 'rubygems/ext/ext_conf_builder.rb'
elsif GEM_VERSION <= Gem::Version.new('3.4.14')
  # NOTE: rubygems 3.4.9 moved the code to builder.rb
  #
  # $ git show v3.4.9:lib/rubygems/ext/builder.rb
  #   cmd = Gem.ruby.shellsplit
  #
  # $ git show v3.4.14:lib/rubygems/ext/builder.rb
  #   cmd = Gem.ruby.shellsplit
  regexp  = /Gem\.ruby\.shellsplit/
  replace = "\\& << '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{target_ruby_version}-orig.rb'"
  builder = 'rubygems/ext/builder.rb'
elsif GEM_VERSION <= Gem::Version.new('3.5.16')
  # $ git show v3.4.9:lib/rubygems/ext/builder.rb
  #     cmd = Shellwords.split(Gem.ruby)
  #
  # $ git show v3.5.10:lib/rubygems/ext/builder.rb
  #     cmd = Shellwords.split(Gem.ruby)
  regexp  = /Shellwords\.split\(Gem\.ruby\)/
  replace = "\\& << '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{target_ruby_version}-orig.rb'"
  builder = 'rubygems/ext/builder.rb'
else
  raise "We don't know how to patch rubygems #{GEM_VERSION}"
end

# path to the builder file on the HOST ruby
builder = File.join(host_rubylibdir, builder)

raise "We can't patch #{builder} because it doesn't exist" unless File.exist?(builder)

# hook rubygems builder so it loads our rbconfig when building native gems
patched = false
rewrite(builder) do |line|
  if line.gsub!(regexp, replace)
    patched = true
  end
end

raise "Failed to patch rubygems hook, because we couldn't match #{regexp} in #{builder}" unless patched

puts "Patched '#{regexp.inspect}' in #{builder}"

# solaris 10 uses ruby 2.0 which doesn't install native extensions based on architecture
if RUBY_PLATFORM !~ /solaris2\.10$/ || RUBY_VERSION != '2.0.0'
  # ensure native extensions are written to a directory that matches the
  # architecture of the target ruby we're building for. To do that we
  # patch the host ruby to pretend to be the target architecture.
  triple_patched = false
  api_version_patched = false
  spec_file = "#{host_rubylibdir}/rubygems/basic_specification.rb"
  rewrite(spec_file) do |line|
    if line.gsub!(/Gem::Platform\.local\.to_s/, "'#{target_triple}'")
      triple_patched = true
    end
    if line.gsub!(/Gem\.extension_api_version/, "'#{target_api_version}'")
      api_version_patched = true
    end
  end

  raise "Failed to patch '#{target_triple}' in #{spec_file}" unless triple_patched
  puts "Patched '#{target_triple}' in #{spec_file}"

  raise "Failed to patch '#{target_api_version}' in #{spec_file}" unless api_version_patched
  puts "Patched '#{target_api_version}' in #{spec_file}"
end
