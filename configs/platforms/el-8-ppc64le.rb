platform 'el-8-ppc64le' do |plat|
  plat.servicedir '/usr/lib/systemd/system'
  plat.defaultdir '/etc/sysconfig'
  plat.servicetype 'systemd'

  packages = %w[make cmake-3.11.4 perl-Getopt-Long gcc-c++ java-1.8.0-openjdk-devel
    patch swig libselinux-devel readline-devel zlib-devel systemtap-sdt-devel]
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
  plat.install_build_dependencies_with 'dnf install -y --allowerasing'
  plat.vmpooler_template 'redhat-8-power8'
end
