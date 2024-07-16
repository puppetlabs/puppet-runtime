# This file is a common basis for multiple rubygem components.
#
# It should not be included as a component itself; Instead, other components
# should load it with instance_eval after setting pkg.version. Parts of this
# shared configuration may be overridden afterward.

name = pkg.get_name.gsub('rubygem-', '')
unless name && !name.empty?
  raise "Rubygem component files that instance_eval _base-rubygem must be named rubygem-<gem-name>.rb"
end

version = pkg.get_version
unless version && !version.empty?
  raise "You must set the `pkg.version` in your rubygem component before instance_eval'ing _base_rubygem.rb"
end

pkg.build_requires "runtime-#{settings[:runtime_project]}"
pkg.build_requires "pl-ruby-patch" if platform.is_cross_compiled?

if platform.is_windows?
  pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:ruby_bindir]}):$(shell cygpath -u #{settings[:bindir]}):/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0:$(PATH)"
end

# When cross-compiling, we can't use the rubygems we just built.
# Instead we use the host gem installation and override GEM_HOME. Yay?
pkg.environment "GEM_HOME", settings[:gem_home]
pkg.environment "GEM_PATH", settings[:gem_home]

# PA-25 in order to install gems in a cross-compiled environment we need to
# set RUBYLIB to include puppet and hiera, so that their gemspecs can resolve
# hiera/version and puppet/version requires. Without this the gem install
# will fail by blowing out the stack.
if settings[:ruby_vendordir]
  pkg.environment "RUBYLIB", "#{settings[:ruby_vendordir]}:$(RUBYLIB)"
end

pkg.url("https://rubygems.org/downloads/#{name}-#{version}.gem")
pkg.mirror("#{settings[:buildsources_url]}/#{name}-#{version}.gem")

# If a gem needs more command line options to install set the :gem_install_options
# in its component file rubygem-<compoment>, before the instance_eval of this file.
gem_install_options = settings["#{pkg.get_name}_gem_install_options".to_sym]
pkg.install do
  steps = []
  if gem_install_options.nil?
    steps << "#{settings[:gem_install]} #{name}-#{version}.gem"
  else
    steps << "#{settings[:gem_install]} #{name}-#{version}.gem #{gem_install_options}"
  end

  # We gem installed rexml to 3.2.9 in ruby 3 for CVE 2024-35176. Since rexml is a bundled gem in ruby 3, we end up having 
  # two versions of rexml -- 1) the bundled version shipped with ruby 3 (3.2.5) and 2) the one we manually installed with 
  # the above gem install command (3.2.9).
  # So, we run gem cleanup so that it deletes the older version 3.2.5. 
  # Note: We won't need to cleanup and install rexml once we upgrade to ruby >= 3.3.3
  if name == 'rexml' && settings[:ruby_version].to_i == 3
    steps << "#{settings[:gem_cleanup]} #{name}"
  end
  steps
end

