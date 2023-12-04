# This file is a basis for multiple versions/targets of ruby-selinux.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y-selinux.rb configs.
#

pkg.add_source("file://resources/patches/ruby-selinux/selinuxswig_ruby_wrap.patch")

# These can be overridden by the including component.
ruby_version ||= settings[:ruby_version]
host_ruby ||= settings[:host_ruby]
ruby_bindir ||= settings[:ruby_bindir]

# We download tarballs because system development packages (e.g.
# libselinux-devel) don't necessarily include Swig interface files (*.i files)
if platform.name =~ /el-(6|7)|ubuntu-(16|18.04-amd64)/
  pkg.version "2.0.94"
  pkg.md5sum "544f75aab11c2af352facc51af12029f"
  pkg.url "https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20100525/devel/libselinux-#{pkg.get_version}.tar.gz"
elsif platform.name.start_with?('el-9')
  # SELinux 3.3 is the minimum version available in RHEL 9 repos
  pkg.version '3.3'
  pkg.sha256sum 'acfdee27633d2496508c28727c3d41d3748076f66d42fccde2e6b9f3463a7057'
  pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
elsif platform.name.start_with?('debian-12')
  # SELinux 3.4 is the minimum version available in Debian 12 repos
  pkg.version '3.4'
  pkg.sha256sum '77c294a927e6795c2e98f74b5c3adde9c8839690e9255b767c5fca6acff9b779'
  pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  pkg.build_requires 'python3-distutils'
else
  pkg.version "2.9"
  pkg.md5sum "bb449431b6ed55a0a0496dbc366d6e31"
  pkg.apply_patch "resources/patches/ruby-selinux/selinux-29-function.patch"
  pkg.url "https://github.com/SELinuxProject/selinux/releases/download/20190315/libselinux-#{pkg.get_version}.tar.gz"
end
pkg.mirror "#{settings[:buildsources_url]}/libselinux-#{pkg.get_version}.tar.gz"

pkg.build_requires "ruby-#{ruby_version}"
cc = "/opt/pl-build-tools/bin/gcc"
system_include = '-I/usr/include'
ruby = "#{ruby_bindir}/ruby -rrbconfig"

# The RHEL 9 libselinux-devel package provides headers, but we don't want to
# use the package becuase of a compatibility issue with the shared library. 
# Instead, we use the headers provided in the tarball.
system_include.prepend('-I./include ') if platform.name.start_with?('el-9')

if platform.is_cross_compiled_linux?
  cc = "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"
  system_include = "-I/opt/pl-build-tools/#{settings[:platform_triple]}/sysroot/usr/include"
  pkg.environment "RUBY", host_ruby
  ruby = "#{host_ruby} -r#{settings[:datadir]}/doc/rbconfig-#{ruby_version}-orig.rb"
end

cflags = ""

# The platforms below use pl-build-tools
unless platform.name =~ /el-(6|7)|ubuntu-(16|18.04-amd64)/
  cc = '/usr/bin/gcc'
  cflags += "#{settings[:cppflags]} #{settings[:cflags]}"
end

pkg.build do
  steps = [
    "export RUBYHDRDIR=$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"rubyhdrdir\"]')",
    "export VENDORARCHDIR=$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"vendorarchdir\"]')",
    "export ARCHDIR=$${RUBYHDRDIR}/$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"arch\"]')",
    "export INCLUDESTR=\"-I#{settings[:includedir]} -I$${RUBYHDRDIR} -I$${ARCHDIR}\"",
    "cp -pr src/{selinuxswig_ruby.i,selinuxswig.i} .",
    "swig -Wall -ruby #{system_include} -o selinuxswig_ruby_wrap.c -outdir ./ selinuxswig_ruby.i"
  ]

  if ruby_version =~ /^3/
    steps << "#{platform.patch} --strip=0 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../selinuxswig_ruby_wrap.patch"
  end

  # libselinux 3.3 is the minimum version we want to build on RHEL 9, but the
  # libeselinux-devel-3.3 package confusingly installs a shared library that
  # uses 3.4. The hacky workaround for this is to symlink an existing library.
  # PDK builds two Rubies so check if symlink exists first.
  if platform.name.start_with?('el-9')
    steps << 'if [ ! -L /usr/lib64/libselinux.so ]; then ln -s /usr/lib64/libselinux.so.1 /usr/lib64/libselinux.so; fi'
  end

  steps.concat([
    "#{cc} $${INCLUDESTR} #{system_include} #{cflags} -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -fPIC -DSHARED -c -o selinuxswig_ruby_wrap.lo selinuxswig_ruby_wrap.c",
    "#{cc} $${INCLUDESTR} #{system_include} -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -shared -o _rubyselinux.so selinuxswig_ruby_wrap.lo -lselinux -Wl,-z,relro,-z,now,-soname,_rubyselinux.so",
  ])
end

pkg.install do
  [
    "export VENDORARCHDIR=$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"vendorarchdir\"]')",
    "install -d $${VENDORARCHDIR}",
    "install -p -m755 _rubyselinux.so $${VENDORARCHDIR}/selinux.so",
    "#{platform[:make]} -e clean",
  ]
end
