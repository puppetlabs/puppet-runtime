component 'rubygem-nokogiri' do |pkg, _settings, _platform|
  pkg.version '1.13.6'
  pkg.sha256sum 'b1512fdc0aba446e1ee30de3e0671518eb363e75fab53486e99e8891d44b8587'
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-mini_portile2'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
