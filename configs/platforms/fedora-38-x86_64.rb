platform 'fedora-38-x86_64' do |plat|
  plat.inherit_from_default

  packages = %w[
    autoconf automake bzip2-devel gcc gcc-c++ libselinux-devel
    libsepol libsepol-devel make cmake pkgconfig readline-devel
    rpmdevtools rsync swig zlib-devel systemtap-sdt-devel
    perl-lib perl-FindBin
  ]
  plat.provision_with("/usr/bin/dnf install -y --best --allowerasing #{packages.join(' ')}")
end
