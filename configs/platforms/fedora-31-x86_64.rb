platform 'fedora-31-x86_64' do |plat|
  plat.inherit_from_default
  packages = %w(
    bzip2-devel
    libselinux-devel
    libsepol 
    libsepol-devel 
    pkgconfig 
    readline-devel
    swig 
    zlib-devel 
    systemtap-sdt-devel
  )
  plat.provision_with "/usr/bin/dnf install -y --best --allowerasing  #{packages.join(' ')}"
end
