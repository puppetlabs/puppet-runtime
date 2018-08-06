platform "ubuntu-14.04-amd64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/default"
  plat.servicetype "sysv"
  plat.codename "trusty"

  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/debian/pl-build-tools-release-#{plat_get_codename}.deb"
  plat.provision_with "curl http://apt.puppetlabs.com/pubkey.gpg | apt-key add - "
  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends build-essential devscripts make quilt pkg-config debhelper fakeroot"
  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "

  packages = [
    "libbz2-dev",
    "libreadline-dev",
    "make",
    "openjdk-7-jdk",
    "pkg-config",
    "pl-cmake",
    "pl-gcc",
    "zlib1g-dev"
  ]

  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends #{packages.join(' ')}"

  plat.vmpooler_template "ubuntu-1404-x86_64"
  plat.output_dir File.join("deb", plat.get_codename, "PC1")
end
