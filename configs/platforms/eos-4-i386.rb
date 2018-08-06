platform "eos-4-i386" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/fedora/14/i386/pl-build-tools-fedora-14.repo"
  plat.add_build_repository "http://osmirror.delivery.puppetlabs.net/eos-4-i386/eos-4-i386.repo"
  packages = [
    "autoconf",
    "automake",
    "createrepo",
    "gcc",
    "make",
    "pkgconfig",
    "pl-cmake",
    "pl-gcc",
    "readline-devel",
    "rpm-build",
    "rpm-libs",
    "rsync",
    "yum-utils",
    "zip",
    "zlib-devel",
  ]
  plat.provision_with("yum install -y --nogpgcheck  #{packages.join(' ')}")
  plat.install_build_dependencies_with "yum install -y --nogpgcheck"
  plat.vmpooler_template "fedora-14-i386"
end
