platform "sles-12-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

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
    "pl-cmake",
    "pl-gcc",
    "readline-devel",
    "rpm-build",
    "rsync",
    "zlib-devel",
    "systemtap-sdt-devel"
  ]
  plat.provision_with("zypper -n --no-gpg-checks install -y #{packages.join(' ')}")
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.vmpooler_template "sles-12-x86_64"
end
