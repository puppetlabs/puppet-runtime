platform 'amazon-2023-aarch64' do |plat|
  plat.inherit_from_default

  packages = %w(
    perl
    perl-Getopt-Long
    java-1.8.0-amazon-corretto-devel
    patch
    swig
    libselinux-devel
    readline-devel
    zlib-devel
    systemtap-sdt-devel
  )
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
  plat.install_build_dependencies_with "dnf install -y --allowerasing "
  plat.vmpooler_template "amazon-2023-arm64"
end
