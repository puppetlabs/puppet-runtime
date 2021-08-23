platform "ubuntu-18.04-aarch64" do |plat|
  plat.inherit_from_default
  plat.clear_provisioning

  packages = %w(
    libbz2-dev
    libreadline-dev
    libselinux1-dev
    openjdk-8-jre-headless
    cmake
    build-essential
    gcc
    swig
    systemtap-sdt-dev
    pkg-config
    zlib1g-dev
  )
  plat.provision_with "export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qy --no-install-recommends #{packages.join(' ')}"
end
