platform "debian-10-amd64" do |plat|
  plat.servicedir "/lib/systemd/system"
  plat.defaultdir "/etc/default"
  plat.servicetype "systemd"
  plat.codename "buster"

  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "

  packages = [
    'build-essential',
    'cmake',
    'debhelper',
    'devscripts',
    'fakeroot',
    'libbz2-dev',
    'libreadline-dev',
    'libselinux1-dev',
    'make',
    'openjdk-11-jdk',
    'pkg-config',
    'quilt',
    'rsync',
    'swig',
    'systemtap-sdt-dev',
    'zlib1g-dev'
  ]

  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends #{packages.join(' ')}"

  plat.vmpooler_template "debian-10-x86_64"
  plat.output_dir File.join("deb", plat.get_codename, "PC1")
end
