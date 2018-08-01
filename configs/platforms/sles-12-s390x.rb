platform "sles-12-s390x" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/sles/12/s390x/pl-build-tools-sles-12-s390x.repo"
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/sles/12/x86_64/pl-build-tools-sles-12-x86_64.repo"
  packages = [
    "aaa_base",
    "autoconf",
    "automake",
    "gcc",
    "java-1_7_0-openjdk-devel",
    "libbz2-devel",
    "make",
    "pkgconfig",
    "pl-binutils-#{self._platform.architecture}",
    "pl-cmake",
    "pl-gcc-#{self._platform.architecture}",
    "pl-ruby",
    "readline-devel",
    "rsync",
    "rpm-build",
    "xorg-x11-util-devel",
    "zlib-devel"
  ]
  plat.provision_with("zypper -n --no-gpg-checks install -y #{packages.join(' ')}")
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.cross_compiled true
  plat.vmpooler_template "sles-12-x86_64"
end
