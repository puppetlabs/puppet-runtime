platform "debian-12-aarch64" do |plat|
    plat.inherit_from_default
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
      'pkg-config',
      'quilt',
      'rsync',
      'swig',
      'systemtap-sdt-dev',
      'zlib1g-dev'
    ]
    plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends #{packages.join(' ')}"
  end