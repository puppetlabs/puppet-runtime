component 'rubygem-highline' do |pkg, settings, _platform|
  pkg.version '2.1.0'
  pkg.md5sum '4209083bda845d47dcc05b7ab23f25fd'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
