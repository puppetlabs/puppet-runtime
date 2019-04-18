platform "debian-10-amd64" do |plat|
  plat.servicedir "/lib/systemd/system"
  plat.defaultdir "/etc/default"
  plat.servicetype "systemd"
  plat.codename "buster"

  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "

  packages = [
      'libbz2-dev',
      'libreadline-dev',
      :make,
      'openjdk-11-jdk',
      'pkg-config',
      'zlib1g-dev',
      'devscripts',
      'quilt',
      'debhelper',
      'rsync',
      'fakeroot',
      'cmake',
      'build-essential',
      'systemtap-sdt-dev'
  ]

  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends #{packages.join(' ')}"

  plat.vmpooler_template "debian-10-x86_64"
  plat.output_dir File.join("deb", plat.get_codename, "PC1")
end
