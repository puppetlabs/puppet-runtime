component 'rubygem-prime' do |pkg, settings, platform|
    pkg.version '0.1.2'
    pkg.sha256sum 'd4e956cadfaf04de036dc7dc74f95bf6a285a62cc509b28b7a66b245d19fe3a4'
  
    instance_eval File.read('configs/components/_base-rubygem.rb')
  end
  