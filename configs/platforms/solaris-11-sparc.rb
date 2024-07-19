platform "solaris-11-sparc" do |plat|
  plat.inherit_from_default
  
  packages = [
    "pl-binutils-sparc",
    "pl-cmake",
    "pl-gcc-sparc",
    "pl-pkg-config",
    "pl-ruby"
  ]

  plat.provision_with("pkg install #{packages.join(' ')}")

  plat.provision_with %[echo "# Write the noask file to a temporary directory
# please see man -s 4 admin for details about this file:
# http://www.opensolarisforum.org/man/man4/admin.html
#
# The key thing we don\'t want to prompt for are conflicting files.
# The other nocheck settings are mostly defensive to prevent prompts
# We _do_ want to check for available free space and abort if there is
# not enough
mail=
# Overwrite already installed instances
instance=overwrite
# Do not bother checking for partially installed packages
partial=nocheck
# Do not bother checking the runlevel
runlevel=nocheck
# Do not bother checking package dependencies (We take care of this)
idepend=nocheck
rdepend=nocheck
# DO check for available free space and abort if there isn\'t enough
space=quit
# Do not check for setuid files.
setuid=nocheck
# Do not check if files conflict with other packages
conflict=nocheck
# We have no action scripts.  Do not check for them.
action=nocheck
# Install to the default base directory.
basedir=default" > /var/tmp/vanagon-noask;
  echo "mirror=https://artifactory.delivery.puppetlabs.net/artifactory/generic__remote_opencsw_mirror/testing" > /var/tmp/vanagon-pkgutil.conf;
  pkgadd -n -a /var/tmp/vanagon-noask -d http://get.opencsw.org/now all
  /opt/csw/bin/pkgutil -U && /opt/csw/bin/pkgutil -y -i gcc4g++ bison CSWxz-5.6.2,REV=2024.06.13 || exit 1

  ntpdate pool.ntp.org]
end
