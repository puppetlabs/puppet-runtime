platform "debian-11-aarch64" do |plat|
    # Delete the 6 lines below when a vanagon with Debian 11 support is released
    plat.servicedir "/lib/systemd/system"
    plat.defaultdir "/etc/default"
    plat.servicetype "systemd"
    plat.codename "bullseye"
    plat.vmpooler_template "debian-11-arm64"
    plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "
  
    # Uncomment these when a vanagon with Debian 11 support is released
    # plat.inherit_from_default
    # plat.clear_provisioning
  
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
  end
  