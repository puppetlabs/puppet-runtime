# This file is a basis for multiple versions/targets of ruby-augeas.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y-augeas.rb configs.
#

pkg.add_source("file://resources/patches/augeas/ruby-augeas-0.5.0-patch_c_extension.patch")

# These can be overridden by the including component.
ruby_version ||= settings[:ruby_version]
host_ruby ||= settings[:host_ruby]
ruby_dir ||= settings[:ruby_dir]
ruby_bindir ||= settings[:ruby_bindir]

pkg.version "0.5.0"
pkg.md5sum "a132eace43ce13ccd059e22c0b1188ac"
pkg.url "http://download.augeas.net/ruby/ruby-augeas-#{pkg.get_version}.tgz"
pkg.mirror "#{settings[:buildsources_url]}/ruby-augeas-#{pkg.get_version}.tgz"

pkg.build_requires "ruby-#{ruby_version}"
pkg.build_requires "augeas"

if platform.name == 'sles-11-x86_64'
  pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
else
  pkg.environment "PATH", "$(PATH):/opt/pl-build-tools/bin:/usr/local/bin:/opt/csw/bin:/usr/ccs/bin:/usr/sfw/bin"
end

if platform.is_aix?
  if platform.name == 'aix-7.1-ppc'
    pkg.environment "CC", "/opt/pl-build-tools/bin/gcc"
    # pl-build-tools was added to PATH above
  else
    pkg.environment "CC", "/opt/freeware/bin/gcc"
    pkg.environment "PATH", "$(PATH):/opt/freeware/bin"
  end
  pkg.environment "RUBY", host_ruby
  pkg.environment "LDFLAGS", " -brtl #{settings[:ldflags]}"
end

pkg.environment "CONFIGURE_ARGS", '--vendor'
pkg.environment "PKG_CONFIG_PATH", "#{File.join(settings[:libdir], 'pkgconfig')}:/usr/lib/pkgconfig"

if platform.is_solaris?
  if platform.is_cross_compiled?
    pkg.environment "RUBY", host_ruby
  end

  if !platform.is_cross_compiled? && platform.architecture == 'sparc'
    ruby = File.join(ruby_bindir, 'ruby')
  else
    # This should really only be done when cross compiling but
    # to avoid breaking solaris x86_64 in 7.x continue preloading
    # our hook.
    ruby = "#{host_ruby} -r#{settings[:datadir]}/doc/rbconfig-#{ruby_version}-orig.rb"
  end
elsif platform.is_cross_compiled?
  if platform.is_linux? || platform.is_macos?
    pkg.environment "RUBY", host_ruby
    pkg.environment 'CC', 'clang -target arm64-apple-macos11' if platform.name =~ /osx-11/
    pkg.environment 'CC', 'clang -target arm64-apple-macos12' if platform.name =~ /osx-12/
    ruby = "#{host_ruby} -r#{settings[:datadir]}/doc/rbconfig-#{ruby_version}-orig.rb"
    pkg.environment "LDFLAGS", settings[:ldflags]
  end
elsif platform.is_macos? && platform.architecture == 'arm64' && platform.os_version.to_i >= 13
  pkg.environment "PATH", "$(PATH):/opt/homebrew/bin"
  pkg.environment 'CC', 'clang'
  pkg.environment "LDFLAGS", settings[:ldflags]
  ruby = File.join(ruby_bindir, 'ruby')
else
  ruby = File.join(ruby_bindir, 'ruby')
end

pkg.build do
  build_commands = []
  if ruby_version =~ /^3/
    build_commands << "#{platform.patch} --strip=2 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../ruby-augeas-0.5.0-patch_c_extension.patch"
  end
  build_commands << "#{ruby} ext/augeas/extconf.rb"
  build_commands << "#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"

  build_commands
end

if settings[:ruby_vendordir]
  augeas_rb_target = File.join(settings[:ruby_vendordir], 'augeas.rb')
else
  # If no alternate vendordir has been set, install into default
  # vendordir for this ruby version.
  augeas_rb_target = File.join(ruby_dir, 'lib', 'ruby', 'vendor_ruby', 'augeas.rb')
end

pkg.install_file 'lib/augeas.rb', augeas_rb_target

pkg.install do
  [
    "#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1) DESTDIR=/ install",
  ]
end

if platform.is_solaris? || platform.is_cross_compiled_linux?
  pkg.install do
    "chown root:root #{augeas_rb_target}"
  end
end

# Clean after install in case we are building for multiple rubies.
pkg.install do
  "#{platform[:make]} -e clean"
end
