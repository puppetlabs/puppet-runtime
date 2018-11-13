# This file is a basis for multiple rubygems.
# It should not be included as a component; Instead other components should
# load it with instance_eval.

pkg.build_requires "runtime-#{settings[:runtime_project]}"

if platform.is_windows?
  # This part applies to all gems except gettext and gettext-setup
  pkg.environment "PATH", "$(cygpath -u #{settings[:gcc_bindir]}):$(cygpath -u #{settings[:ruby_bindir]}):$(cygpath -u #{settings[:bindir]}):/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0"
end

# When cross-compiling, we can't use the rubygems we just built.
# Instead we use the host gem installation and override GEM_HOME. Yay?
pkg.environment "GEM_HOME", settings[:gem_home]

# PA-25 in order to install gems in a cross-compiled environment we need to
# set RUBYLIB to include puppet and hiera, so that their gemspecs can resolve
# hiera/version and puppet/version requires. Without this the gem install
# will fail by blowing out the stack.
if settings[:ruby_vendordir]
  pkg.environment "RUBYLIB", "#{settings[:ruby_vendordir]}:${RUBYLIB}"
end
