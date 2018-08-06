platform "sles-11-s390x" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.add_build_repository "http://osmirror.delivery.puppetlabs.net/sles-11-deps-x86_64/sles-11-deps-x86_64.repo"
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/sles/11/s390x/pl-build-tools-sles-11-s390x.repo"
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/pl-build-tools-release-#{plat.get_os_name}-#{plat.get_os_version}.noarch.rpm"
  packages = [
    "aaa_base",
    "autoconf",
    "automake",
    "gcc",
    "java-1_7_0-ibm-devel",
    "libbz2-devel",
    "make",
    "pkgconfig",
    "pl-binutils-#{self._platform.architecture}",
    "pl-cmake",
    "pl-gcc-#{self._platform.architecture}",
    "pl-ruby",
    "readline-devel",
    "rsync",
    "xorg-x11-util-devel",
    "zlib-devel"
  ]
  plat.provision_with("zypper -n --no-gpg-checks install -y #{packages.join(' ')}")
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.cross_compiled true
  plat.vmpooler_template "sles-11-x86_64"
end
