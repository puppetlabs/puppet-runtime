platform "el-9-x86_64" do |plat|
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
  plat.provision_with("sed -i 's/beta-x86_64\/baseos\/x86_64/base/' /etc/yum.repos.d/localmirror-baseos.repo; sed -i 's/beta-x86_64\/appstream\/x86_64/appstream/' /etc/yum.repos.d/localmirror-appstream.repo")
end
