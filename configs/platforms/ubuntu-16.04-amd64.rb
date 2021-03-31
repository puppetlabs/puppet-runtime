platform "ubuntu-16.04-amd64" do |plat|
  plat.inherit_from_default

  packages = %w(
    libbz2-dev
    libreadline-dev
    libselinux1-dev
    openjdk-8-jdk
    pkg-config
    pl-cmake
    pl-gcc
    swig
    systemtap-sdt-dev
    zlib1g-dev
  )
  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends #{packages.join(' ')}"
end
