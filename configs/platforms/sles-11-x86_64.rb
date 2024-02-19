platform "sles-11-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"
  plat.add_build_repository "http://osmirror.delivery.puppetlabs.net/sles-11-deps-x86_64/sles-11-deps-x86_64.repo"
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/sles/11/x86_64/pl-build-tools-sles-11-x86_64.repo"
  packages = [
    "aaa_base",
    "libbz2-devel",
    "make",
    "pkgconfig",
    "pl-autotools",
    "pl-cmake",
    "pl-gcc",
    "readline-devel",
    "rsync",
    "zlib-devel"
  ]
  plat.provision_with("zypper -n --no-gpg-checks install -y #{packages.join(' ')}")
  plat.provision_with "zypper install -y --oldpackage pl-gcc=4.8.2-1"
  plat.provision_with "zypper install -y --oldpackage pl-cmake=3.2.3-13.sles11"
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.vmpooler_template "sles-11-x86_64"
end
