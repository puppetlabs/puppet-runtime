platform "redhatfips-7-x86_64" do |plat|
  plat.inherit_from_default

  packages = %w(
    java-1.8.0-openjdk-devel
    libsepol
    libsepol-devel
    libselinux-devel
    openssl-devel
    pkgconfig
    pl-cmake
    pl-gcc
    readline-devel
    rpm-build
    swig zlib-devel
  )
  plat.provision_with "yum install --assumeyes #{packages.join(' ')}"
end
