platform "aix-6.1-ppc" do |plat|
  plat.servicetype "aix"

  plat.make "gmake"
  plat.tar "/opt/freeware/bin/tar"
  plat.rpmbuild "/usr/bin/rpm"
  plat.patch "/opt/freeware/bin/patch"

  # Basic vanagon operations require mktemp, rsync, coreutils, make, tar and sed so leave this in there
  plat.provision_with "curl -O https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/ppc/perl/perl-5.22.0-1.aix6.1.ppc.rpm"
  plat.provision_with "curl -O https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/ppc/gdbm/gdbm-1.8.3-5.aix5.2.ppc.rpm"
  plat.provision_with "curl -O https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/ppc/db/db-4.8.24-3.aix6.1.ppc.rpm"
  plat.provision_with "curl -O https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_aix_linux_toolbox/ppc/binutils/binutils-2.25.1-1.aix6.1.ppc.rpm"
  plat.provision_with "rpm -Uvh binutils-2.25.1-1.aix6.1.ppc.rpm"
  plat.provision_with "rpm -Uvh db-4.8.24-3.aix6.1.ppc.rpm"
  plat.provision_with "rpm -Uvh gdbm-1.8.3-5.aix5.2.ppc.rpm"
  plat.provision_with "rpm -Uvh perl-5.22.0-1.aix6.1.ppc.rpm"
  plat.provision_with "rm db-4.8.24-3.aix6.1.ppc.rpm"
  plat.provision_with "rm perl-5.22.0-1.aix6.1.ppc.rpm"
  plat.provision_with "rm gdbm-1.8.3-5.aix5.2.ppc.rpm"
  # plat.provision_with "rm db-6.2.32-1.aix6.1.ppc.rpm"
  plat.provision_with "rpm -Uvh --replacepkgs http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/mktemp-1.7-1.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/rsync-3.0.6-1.aix5.3.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/coreutils-5.2.1-2.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/sed-4.1.1-1.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/tar-1.22-1.aix6.1.ppc.rpm"

  # We use --force with rpm because the pl-gettext and pl-autoconf
  # packages conflict with a charset.alias file.
  #
  # Until we get those packages to not conflict (or we remove the need
  # for pl-autoconf) we'll need to force the installation
  #                                         Sean P. McD.
  plat.install_build_dependencies_with "rpm -Uvh --replacepkgs --force "
  plat.vmpooler_template "aix-6.1-power"
end
