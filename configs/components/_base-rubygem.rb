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

if name =~ /ffi/ && settings[:ruby_version].to_f >= 3.2 && platform.is_solaris?
  extra_install_settings = ' -- --enable-system-libffi'
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

pkg.install do
  "#{settings[:gem_install]} #{name}-#{version}.gem#{extra_install_settings}"
end
