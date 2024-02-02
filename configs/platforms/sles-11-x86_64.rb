platform "sles-11-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"
  plat.add_build_repository "http://osmirror.delivery.puppetlabs.net/sles-11-deps-x86_64/sles-11-deps-x86_64.repo"
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/sles/11/x86_64/pl-build-tools-sles-11-x86_64.repo"
  packages = [
    "aaa_base",
    "autoconf",
    "automake",
    "libbz2-devel",
    "make",
    "pkgconfig",
    "pl-cmake",
    "pl-gcc",
    "readline-devel",
    "rsync",
    "zlib-devel"
  ]
  plat.provision_with(%q{cat <<END > /etc/zypp/repos.d/localmirror-os.repo
    [localmirror-os]
    name=localmirror-os
    baseurl=http://osmirror.delivery.puppetlabs.net/sles-11-sp4-x86_64/RPMS.os
    enabled=1
    gpgcheck=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-SLES-11
    autorefresh=1
    type=rpm-md 
    END})
  plat.provision_with("zypper -n --no-gpg-checks install -y #{packages.join(' ')}")
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.vmpooler_template "sles-11-x86_64"
end
