component 'rubygem-optimist' do |pkg, settings, _platform|
  pkg.version '3.0.1'
  pkg.md5sum 'ce7ee8dac7e34793756680c2af9a8ee9'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
