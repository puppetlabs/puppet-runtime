platform "el-6-x86_64" do |plat|
  plat.inherit_from_default

  packages = %w(
    bzip2-devel
    java-1.8.0-openjdk-devel
    libsepol
    libsepol-devel
    libselinux-devel
    pkgconfig
    pl-cmake
    pl-gcc
    readline-devel
    rpm-build
    swig
    zlib-devel
    systemtap-sdt-devel
  )
  plat.provision_with "yum install --assumeyes --nogpgcheck #{packages.join(' ')}"
end
