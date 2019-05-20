platform "el-7-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  plat.provision_with "rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs"
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/pl-build-tools-release-el-7.noarch.rpm"
  packages = [
    "autoconf",
    "automake",
    "bzip2-devel",
    "createrepo",
    "gcc",
    "java-1.8.0-openjdk-devel",
    "libsepol",
    "libsepol-devel",
    "libselinux-devel",
    "make",
    "pkgconfig",
    "pl-cmake",
    "pl-gcc",
    "readline-devel",
    "rsync",
    "rpm-build",
    "rpm-libs",
    "rpm-sign",
    "rpmdevtools",
    "swig",
    "yum-utils",
    "zlib-devel",
    "systemtap-sdt-devel"
  ]
  plat.provision_with("yum install -y --nogpgcheck  #{packages.join(' ')}")
  plat.install_build_dependencies_with "yum install --assumeyes"
  plat.vmpooler_template "centos-7-x86_64"
end
