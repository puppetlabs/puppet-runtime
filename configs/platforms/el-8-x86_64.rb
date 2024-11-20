platform "el-8-x86_64" do |plat|
  plat.inherit_from_default

  packages = %w(
    libsepol
    libsepol-devel
    libselinux-devel
    pkgconfig 
    python3.11
    readline-devel
    rpmdevtools
    swig
    systemtap-sdt-devel
    yum-utils
    zlib-devel
  )
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
end
