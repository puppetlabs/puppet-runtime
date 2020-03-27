platform "ubuntu-20.04-amd64" do |plat|
  plat.servicedir "/lib/systemd/system"
  plat.defaultdir "/etc/default"
  plat.servicetype "systemd"
  plat.codename "focal"

  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "

  packages = [
    "build-essential",
    "devscripts",
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
    "openjdk-8-jre-headless",
    "pkg-config",
    "cmake",
    "gcc",
    "swig",
    "systemtap-sdt-dev",
    "zlib1g-dev"
  ]

  plat.provision_with "export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qy --no-install-recommends #{packages.join(' ')}"

  plat.vmpooler_template "ubuntu-2004-x86_64"
  plat.output_dir File.join("deb", plat.get_codename, "PC1")
end
