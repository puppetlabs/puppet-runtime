component "rubygem-scanf" do |pkg, settings, platform|
  pkg.version '1.0.0'
  pkg.md5sum "6a48b02b5d7109331afa8bd9d55a802e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
