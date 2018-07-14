platform "aix-6.1-ppc" do |plat|
  plat.servicetype "aix"

  plat.make "gmake"
  plat.tar "/opt/freeware/bin/tar"
  plat.rpmbuild "/usr/bin/rpm"
  plat.patch "/opt/freeware/bin/patch"

  # Basic vanagon operations require mktemp, rsync, coreutils, make, tar and sed so leave this in there
  plat.provision_with "curl http://pl-build-tools.delivery.puppetlabs.net/aix/yum_bootstrap/openssl-1.0.2.1500.tar | tar xvf - && cd openssl-1.0.2.1500 && installp -acXYgd . openssl.base all"
  plat.provision_with "rpm --rebuilddb && updtvpkg"
  plat.provision_with "curl http://pl-build-tools.delivery.puppetlabs.net/aix/yum_bootstrap/yum.sh | sh"
  # plat.provision_with "yum update -y --skip-broken"
  plat.provision_with "yum install -y rsync coreutils sed make tar pkg-config zlib zlib-devel gawk autoconf gcc glib2"
  plat.install_build_dependencies_with "yum install -y "
  plat.vmpooler_template "aix-6.1-power"
end
