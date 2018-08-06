platform "el-6-s390x" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/el/6/s390x/pl-build-tools-s390x.repo"
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/el/6/x86_64/pl-build-tools-x86_64.repo"
  packages = [
    "autoconf",
    "automake",
    "createrepo",
    "gcc",
    "java-1.8.0-openjdk-devel",
    "libsepol",
    "libsepol-devel",
    "libselinux-devel",
    "make",
    "pkgconfig",
    "pl-binutils-#{self._platform.architecture}",
    "pl-cmake",
    "pl-gcc-#{self._platform.architecture}",
    "pl-ruby",
    "readline-devel",
    "rsync",
    "rpm-build",
    "rpm-libs",
    "rpm-sign",
    "rpmdevtools",
    "swig",
    "yum-utils",
  ]
  plat.provision_with("yum install -y --nogpgcheck  #{packages.join(' ')}")
  plat.install_build_dependencies_with "yum install --assumeyes"
  plat.cross_compiled true
  plat.vmpooler_template "redhat-6-x86_64"
end
