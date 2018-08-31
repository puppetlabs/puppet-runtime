platform "sles-15-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  # Note that SLES 15 runtime builds are using the OS toolchain by default
  # and do not rely on pl-build-tools packages.
  packages = [
    "aaa_base",
    "autoconf",
    "automake",
    "gcc",
    "java-1_8_0-openjdk-devel",
    "libbz2-devel",
    "make",
    "pkg-config",
    "cmake",
    "readline-devel",
    "rpm-build",
    "rsync",
    "zlib-devel"
  ]
  plat.provision_with("zypper -n --no-gpg-checks install -y #{packages.join(' ')}")
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.vmpooler_template "sles-15-x86_64"
end
