component 'rubygem-nokogiri' do |pkg, _settings, _platform|
  pkg.version '1.13.9'
  pkg.sha256sum '96f37c1baf0234d3ae54c2c89aef7220d4a8a1b03d2675ff7723565b0a095531'
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-mini_portile2'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
