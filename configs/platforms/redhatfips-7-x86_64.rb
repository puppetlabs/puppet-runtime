platform "redhatfips-7-x86_64" do |plat|
  plat.inherit_from_default

  packages = %w(
    pl-cmake
    pl-gcc
  )
  plat.provision_with "yum install --assumeyes #{packages.join(' ')}"
end
