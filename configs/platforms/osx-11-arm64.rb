platform 'osx-11-arm64' do |plat|
  plat.inherit_from_default

  packages = %w[cmake pkg-config]
  plat.provision_with "su test -c '/usr/local/bin/brew install #{packages.join(' ')}'"

  plat.output_dir File.join('apple', '11', 'PC1', 'arm64')
end
