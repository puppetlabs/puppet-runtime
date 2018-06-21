platform "aix-6.1-ppc" do |plat|
  plat.servicetype "aix"

  plat.make "gmake"
  plat.tar "/opt/freeware/bin/tar"
  plat.rpmbuild "/usr/bin/rpm"
  plat.patch "/opt/freeware/bin/patch"

  os_version = 6.1
  # We can't rely on yum, and rpm can't download over https on AIX, so curl packages before installing them
  # Order matters here - there is no automatic dependency resolution
  packages = [
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_oss4aix.org/RPMS/mktemp/mktemp-1.7-1.aix5.1.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/rsync/rsync-3.0.6-1.aix5.3.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/coreutils/coreutils-5.2.1-2.aix5.1.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/sed/sed-4.1.1-1.aix5.1.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/make/make-3.80-1.aix5.1.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/tar/tar-1.22-1.aix6.1.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/pkg-config/pkg-config-0.19-6.aix5.2.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/zlib/zlib-1.2.3-4.aix5.2.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/zlib/zlib-devel-1.2.3-4.aix5.2.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/gawk/gawk-3.1.3-1.aix5.1.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/db/db-4.8.24-3.aix6.1.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/gdbm/gdbm-1.8.3-5.aix5.2.ppc.rpm",
    "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/RPMS/ppc/perl/perl-5.22.0-1.aix6.1.ppc.rpm",
    "http://pl-build-tools.delivery.puppetlabs.net/aix/#{os_version}/ppc/pl-gcc-5.2.0-11.aix#{os_version}.ppc.rpm",
    "http://pl-build-tools.delivery.puppetlabs.net/aix/#{os_version}/ppc/pl-cmake-3.2.3-2.aix#{os_version}.ppc.rpm",
  ]

  packages.each do |uri|
    name = uri.split("/").last
    plat.provision_with("curl -O #{uri} > /dev/null")
    plat.provision_with("rpm -Uvh --replacepkgs --nodeps #{name}")
  end

  # We use --force with rpm because the pl-gettext and pl-autoconf
  # packages conflict with a charset.alias file.
  #
  # Until we get those packages to not conflict (or we remove the need
  # for pl-autoconf) we'll need to force the installation
  #                                         Sean P. McD.
  plat.install_build_dependencies_with "rpm -Uvh --replacepkgs --force "
  plat.vmpooler_template "aix-6.1-power"
end
