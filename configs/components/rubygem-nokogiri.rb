component 'rubygem-nokogiri' do |pkg, _settings, _platform|
  pkg.version '1.13.3'
  pkg.sha256sum 'bf1b1bceff910abb0b7ad825535951101a0361b859c2ad1be155c010081ecbdc'
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-racc'
  pkg.build_requires 'rubygem-mini_portile2'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
