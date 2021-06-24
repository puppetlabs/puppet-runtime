platform "el-8-x86_64" do |plat|
  plat.inherit_from_default

  packages = %w(
    java-1.8.0-openjdk-devel
    libsepol
    libsepol-devel
    libselinux-devel
    pkgconfig 
    readline-devel
    rpmdevtools
    swig
    systemtap-sdt-devel
    yum-utils
    zlib-devel
  )
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
end
