platform "el-5-x86_64" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/pl-build-tools-release-#{plat.get_os_name}-#{plat.get_os_version}.noarch.rpm"
  plat.provision_with "echo '[build-tools]\nname=build-tools\nbaseurl=http://enterprise.delivery.puppetlabs.net/build-tools/el/5/$basearch\ngpgcheck=0' > /etc/yum.repos.d/build-tools.repo"
  packages = [
    "autoconf",
    "automake",
    "bzip2-devel",
    "createrepo",
    "gcc",
    "libsepol",
    "libsepol-devel",
    "libselinux-devel",
    "make",
    "pkgconfig",
    "pl-cmake",
    "pl-gcc",
    "pl-perl",
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
  plat.install_build_dependencies_with "yum install -y --nogpgcheck"

  packages = ['libffi-3.0.5-1.el5.x86_64.rpm', 'libffi-devel-3.0.5-1.el5.x86_64.rpm']

  packages.each do |package|
    plat.provision_with("wget http://artifactory.delivery.puppetlabs.net/artifactory/generic__buildsources/buildsources/#{package}")
    plat.provision_with("rpm -i #{package}")
  end
  plat.vmpooler_template "centos-5-x86_64"
end
