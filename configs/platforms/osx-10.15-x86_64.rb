platform 'osx-10.15-x86_64' do |plat|
  plat.inherit_from_default
  packages = %w(
    cmake
    pkg-config
    yaml-cpp
    readline
  )
  plat.provision_with "su test -c '/usr/local/bin/brew install #{packages.join(' ')}'"
end
