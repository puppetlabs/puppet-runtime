component "rubygem-locale" do |pkg, settings, platform|
  pkg.version "2.1.3"
  pkg.md5sum "f5bef9eed8e8c40417a3ab68fa34f477"

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
