platform "fedora-27-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/pl-build-tools-release-#{plat.get_os_name}-27.noarch.rpm"
  packages = [
    "autoconf",
    "automake",
    "bzip2-devel",
    "gcc",
    "libselinux-devel",
    "libsepol",
    "libsepol-devel",
    "make",
    "pkgconfig",
    "pl-cmake",
    "pl-gcc",
    "readline-devel",
    "rpm-libs",
    "rpmdevtools",
    "rsync",
    "swig",
    "zlib-devel"
  ]
  plat.provision_with("/usr/bin/dnf install -y --best --allowerasing #{packages.join(' ')}")
  plat.install_build_dependencies_with "/usr/bin/dnf install -y --best --allowerasing"
  plat.vmpooler_template "fedora-27-x86_64"
  plat.dist "fc27"
end
