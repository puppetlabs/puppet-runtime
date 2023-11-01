platform "el-6-i386" do |plat|
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
  plat.provision_with("yum install -y --nogpgcheck  #{packages.join(' ')}")
end
