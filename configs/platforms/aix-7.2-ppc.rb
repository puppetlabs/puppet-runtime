platform "aix-7.2-ppc" do |plat|
  # os_version = 7.2
  plat.make "gmake"
  plat.patch "/opt/freeware/bin/patch"
  plat.rpmbuild "/usr/bin/rpm"
  plat.servicetype "aix"
  plat.tar "/opt/freeware/bin/tar"

  plat.provision_with %[
curl -O https://artifactory.delivery.puppetlabs.net/artifactory/generic__buildsources/openssl-1.1.2.2000.tar.Z;
uncompress openssl-1.1.2.2000.tar.Z;
tar xvf openssl-1.1.2.2000.tar;
cd openssl-1.1.2.2000 && /usr/sbin/installp -acgwXY -d $PWD openssl.base;
curl --output yum.sh https://artifactory.delivery.puppetlabs.net/artifactory/generic__buildsources/buildsources/aix-yum.sh && sh yum.sh]

  # After installing yum, but before yum installing packages, point yum to artifactory
  # AIX sed doesn't support in-place replacement, so download GNU sed and use that
  plat.provision_with %[
rpm -Uvh https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/sed/sed-4.1.1-1.aix5.1.ppc.rpm;
/opt/freeware/bin/sed -i 's|https://anonymous:anonymous@public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/RPMS|https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS|' /opt/freeware/etc/yum/yum.conf]

  packages = %w(
    autoconf
    cmake
    coreutils
    curl-7.86.0
    gawk
    gcc
    gcc-c++
    gdbm
    gmp
    libffi
    libyaml
    make
    perl
    pkg-config
    readline
    readline-devel
    sed
    tar
    zlib
    zlib-devel
  )
  plat.provision_with "yum install --assumeyes #{packages.join(' ')}"

  # No upstream rsync packages
  plat.provision_with "rpm -Uvh https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/rsync/rsync-3.0.6-1.aix5.3.ppc.rpm"

  # lots of things expect mktemp to be installed in the usual place, so link it
  plat.provision_with "ln -sf /opt/freeware/bin/mktemp /usr/bin/mktemp"

  plat.install_build_dependencies_with "yum install --assumeyes "
  plat.vmpooler_template "aix-7.2-power"
end
