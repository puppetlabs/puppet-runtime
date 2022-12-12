component 'rubygem-nokogiri' do |pkg, _settings, _platform|
  pkg.version '1.13.10'
  pkg.sha256sum 'd3ee00f26c151763da1691c7fc6871ddd03e532f74f85101f5acedc2d099e958'
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-mini_portile2'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
