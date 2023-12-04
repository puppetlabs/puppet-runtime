platform "debian-12-armhf" do |plat|
  plat.servicedir "/lib/systemd/system"
  plat.defaultdir "/etc/default"
  plat.servicetype "systemd"
  plat.codename "bullseye"

  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "

  packages = [
    "build-essential",
    "make",
    "quilt",
    "pkg-config",
    "debhelper",
    "rsync",
    "fakeroot",
    "libbz2-dev",
    "libreadline-dev",
    "libselinux1-dev",
    "make",
    "pkg-config",
    "cmake",
    "gcc",
    "swig",
    "systemtap-sdt-dev",
    "zlib1g-dev"
  ]

  plat.provision_with "export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qy --no-install-recommends #{packages.join(' ')}"
end
