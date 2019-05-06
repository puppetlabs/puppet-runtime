component "rubygem-locale" do |pkg, settings, platform|
  pkg.version "2.1.2"
  pkg.md5sum "def1e89d1d3126a0c684d3b7b20d88d4"

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
