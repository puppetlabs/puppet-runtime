platform "el-7-x86_64" do |plat|
  plat.inherit_from_default
  packages = %w(
    bzip2-devel
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
  plat.provision_with("yum install --assumeyes  #{packages.join(' ')}")
end
