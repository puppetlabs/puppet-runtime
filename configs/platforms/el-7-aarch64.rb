platform "el-7-aarch64" do |plat|
  plat.inherit_from_default
  packages = [
    "bison",
    "gcc-c++",
    "imake",
    "java-1.8.0-openjdk-devel",
    "libsepol",
    "libsepol-devel",
    "libselinux-devel",
    "pkgconfig",
    "pl-binutils-#{self._platform.architecture}",
    "pl-cmake",
    "pl-gcc-#{self._platform.architecture}",
    "pl-ruby",
    "readline-devel",
    "rpm-build",
    "swig",
  ]
  plat.provision_with "yum install --assumeyes #{packages.join(' ')}"
end
