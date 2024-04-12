component "rubygem-locale" do |pkg, settings, platform|
  pkg.version "2.1.4"
  pkg.md5sum "c324a7f34b94044f8d38eabff159de62"

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
