component 'rubygem-racc' do |pkg, _settings, _platform|
  pkg.version '1.6.0'
  pkg.sha256sum '2dede3b136eeabd0f7b8c9356b958b3d743c00158e2615acab431af141354551'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
