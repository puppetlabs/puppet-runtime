platform "el-9-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  # Temporary fix until new rhel 9 image is built
  if File.exist?("/etc/yum.repos.d/localmirror-appstream.repo")
    plat.provision_with("sed -i 's/beta-x86_64\\/baseos\\/x86_64/base/' /etc/yum.repos.d/localmirror-baseos.repo; sed -i 's/beta-x86_64\\/appstream\\/x86_64/appstream/' /etc/yum.repos.d/localmirror-appstream.repo")
  end

  packages = %w(
    gcc
    gcc-c++
    autoconf
    automake
    createrepo
    rsync
    cmake
    make
    rpm-libs
    rpm-build
    rpm-sign
    libtool
    libarchive
    java-1.8.0-openjdk-devel
    libsepol
    libsepol-devel
    pkgconfig
    readline-devel
    rpmdevtools
    swig
    systemtap-sdt-devel
    yum-utils
    zlib-devel
  )

  plat.provision_with "dnf install -y --allowerasing #{packages.join(' ')}"
  plat.install_build_dependencies_with "dnf install -y --allowerasing "
  plat.vmpooler_template "redhat-9-x86_64"
end

