component "rubygem-multi_json" do |pkg, settings, platform|
  pkg.version '1.15.0'
  pkg.md5sum '06f0ae43e84ec7b9357f4095f8417cd5'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
