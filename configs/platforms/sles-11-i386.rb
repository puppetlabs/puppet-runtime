platform "sles-11-i386" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/pl-build-tools-release-#{plat.get_os_name}-#{plat.get_os_version}.noarch.rpm"
  packages = [
    "aaa_base",
    "autoconf",
    "automake",
    "gcc",
    "java-1_7_1-ibm-devel",
    "libbz2-devel",
    "make",
    "pkgconfig",
    "pl-cmake",
    "pl-gcc",
    "readline-devel",
    "rsync",
    "zlib-devel"
  ]
  plat.provision_with("zypper -n --no-gpg-checks install -y #{packages.join(' ')}")
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.vmpooler_template "sles-11-i386"
end
