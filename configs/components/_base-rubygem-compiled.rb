# This file is a common basis for multiple rubygem components.
#
# It is used with gems that have native extensions that need compilation on windows
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
  raise "You must set the `pkg.version` in your rubygem component before instance_eval'ing _base-rubygem-native-extension.rb"
end

pkg.build_requires "runtime-#{settings[:runtime_project]}"
pkg.build_requires "pl-ruby-patch" if platform.is_cross_compiled?

if platform.is_windows?
  # This part applies to all gems except gettext and gettext-setup
  pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:ruby_bindir]}):$(shell cygpath -u #{settings[:bindir]}):/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0"
end

# When cross-compiling, we can't use the rubygems we just built.
# Instead we use the host gem installation and override GEM_HOME. Yay?
pkg.environment "GEM_HOME", settings[:gem_home]

# PA-25 in order to install gems in a cross-compiled environment we need to
# set RUBYLIB to include puppet and hiera, so that their gemspecs can resolve
# hiera/version and puppet/version requires. Without this the gem install
# will fail by blowing out the stack.
if settings[:ruby_vendordir]
  pkg.environment "RUBYLIB", "#{settings[:ruby_vendordir]}:$(RUBYLIB)"
end

if platform.is_windows?
  pkg.url("http://rubygems.org/downloads/#{name}-#{version}-x64-mingw32.gem")
  pkg.mirror("#{settings[:buildsources_url]}/#{name}-#{version}-x64-mingw32.gem")
  pkg.install do
    "#{settings[:gem_install]} #{name}-#{version}-x64-mingw32.gem"
  end
else
  pkg.url("https://rubygems.org/downloads/#{name}-#{version}.gem")
  pkg.mirror("#{settings[:buildsources_url]}/#{name}-#{version}.gem")
  pkg.install do
    "#{settings[:gem_install]} #{name}-#{version}.gem"
  end
end
