platform 'el-8-aarch64' do |plat|
  plat.inherit_from_default

  packages = %w(
    perl-Getopt-Long 
    patch 
    swig 
    libselinux-devel 
    readline-devel 
    zlib-devel 
    systemtap-sdt-devel
  )
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
end
