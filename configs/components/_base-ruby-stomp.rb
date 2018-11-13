# This file is a basis for multiple versions/targets of ruby-stomp.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y-stomp.rb configs.
#

# These can be overridden by the including component.
ruby_version ||= settings[:ruby_version]
ruby_bindir ||= settings[:ruby_bindir]
gem_home ||= settings[:gem_home]
gem_install ||= settings[:gem_install]

# Projects may define a :ruby_stomp_version setting, or we use 1.4.4 by default:
version = settings[:ruby_stomp_version] || '1.4.4'
pkg.version version

case version
when '1.4.4'
  pkg.md5sum "1224b9efe7381cea25c506c9c6e28373"
when '1.3.3'
  pkg.md5sum "50a2c1b66982b426d67a83f56f4bc0e2"
else
  raise "ruby-stomp version #{version} has not been configured; Cannot continue."
end

pkg.url "https://rubygems.org/downloads/stomp-#{pkg.get_version}.gem"
pkg.mirror "#{settings[:buildsources_url]}/stomp-#{pkg.get_version}.gem"

pkg.build_requires "ruby-#{ruby_version}"

# Because we are cross-compiling on sparc, we can't use the rubygems we just built.
# Instead we use the host gem installation and override GEM_HOME. Yay?
pkg.environment "GEM_HOME", gem_home

if platform.is_windows?
  pkg.environment "PATH", "$(cygpath -u #{settings[:gcc_bindir]}):$(cygpath -u #{ruby_bindir}):$(cygpath -u #{settings[:bindir]}):/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0"
end

# PA-25 in order to install gems in a cross-compiled environment we need to
# set RUBYLIB to include puppet and hiera, so that their gemspecs can resolve
# hiera/version and puppet/version requires. Without this the gem install
# will fail by blowing out the stack.
if settings[:ruby_vendordir]
  pkg.environment "RUBYLIB", "#{settings[:ruby_vendordir]}:${RUBYLIB}"
end

if version == '1.3.3'
  base = 'resources/patches/ruby-stomp'
  pkg.apply_patch "#{base}/verify_client_certs.patch", destination: "#{gem_home}/gems/stomp-#{pkg.get_version}", after: "install"
  pkg.apply_patch "#{base}/connection_loss_reconnect_fix.patch", destination: "#{gem_home}/gems/stomp-#{pkg.get_version}", after: "install"
end

pkg.install do
  ["#{gem_install} stomp-#{pkg.get_version}.gem"]
end
