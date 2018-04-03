# This file is a basis for multiple versions/targets of ruby-augeas.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y-augeas.rb configs.
#

# These can be overridden by the including component.
ruby_version ||= settings[:ruby_version]
host_ruby ||= settings[:host_ruby]
ruby_dir ||= settings[:ruby_dir]
ruby_bindir ||= settings[:ruby_bindir]

pkg.version "0.5.0"
pkg.md5sum "a132eace43ce13ccd059e22c0b1188ac"
pkg.url "http://download.augeas.net/ruby/ruby-augeas-#{pkg.get_version}.tgz"
pkg.mirror "#{settings[:buildsources_url]}/ruby-augeas-#{pkg.get_version}.tar.gz"

pkg.build_requires "ruby-#{ruby_version}"
pkg.build_requires "augeas"

pkg.environment "PATH", "$(PATH):/opt/pl-build-tools/bin:/usr/local/bin:/opt/csw/bin:/usr/ccs/bin:/usr/sfw/bin"
if platform.is_aix?
  pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/pkg-config-0.19-6.aix5.2.ppc.rpm"
  pkg.environment "CC", "/opt/pl-build-tools/bin/gcc"
  pkg.environment "RUBY", host_ruby
  pkg.environment "LDFLAGS", " -brtl #{settings[:ldflags]}"
end

pkg.environment "CONFIGURE_ARGS", '--vendor'
pkg.environment "PKG_CONFIG_PATH", "#{File.join(settings[:libdir], 'pkgconfig')}:/usr/lib/pkgconfig"

if platform.is_solaris?
  if platform.architecture == 'sparc'
    pkg.environment "RUBY", host_ruby
  end
  ruby = "#{host_ruby} -r#{settings[:datadir]}/doc/rbconfig-#{ruby_version}-orig.rb"
elsif platform.is_cross_compiled_linux?
  pkg.environment "RUBY", host_ruby
  ruby = "#{host_ruby} -r#{settings[:datadir]}/doc/rbconfig-#{ruby_version}-orig.rb"
  pkg.environment "LDFLAGS", settings[:ldflags]
else
  ruby = File.join(ruby_bindir, 'ruby')
end

# This is a disturbing workaround needed for s390x based systems, that
# for some reason isn't encountered with our other architecture cross
# builds. When trying to build the augeas test cases for extconf.rb,
# the process fails with "/opt/pl-build-tools/bin/s390x-linux-gnu-gcc:
# error while loading shared libraries: /opt/puppetlabs/puppet/lib/libstdc++.so.6:
# ELF file data encoding not little-endian". It will also complain in
# the same way about libgcc. If however we temporarily move these
# libraries out of the way, extconf.rb and the cross-compile work
# properly. This needs to be fixed, but I've spent over a week analyzing
# every possible angle that could cause this, from rbconfig settings to
# strace logs, and we need to move forward on this platform.
# FIXME: Scott Garman Jun 2016
if platform.architecture == "s390x"
  pkg.configure do
    [
      "mkdir #{settings[:libdir]}/hide",
      "mv #{settings[:libdir]}/libstdc* #{settings[:libdir]}/hide/",
      "mv #{settings[:libdir]}/libgcc* #{settings[:libdir]}/hide/"
    ]
  end
end

pkg.build do
  build_commands = []
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

# Undo the gross hack from the configure step
if platform.architecture == "s390x"
  pkg.install do
    [
      "mv #{settings[:libdir]}/hide/* #{settings[:libdir]}/",
      "rmdir #{settings[:libdir]}/hide/"
    ]
  end
end

# Clean after install in case we are building for multiple rubies.
pkg.install do
  "#{platform[:make]} -e clean"
end
