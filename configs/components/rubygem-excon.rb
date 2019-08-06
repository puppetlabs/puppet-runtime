component 'rubygem-excon' do |pkg, settings, platform|
  pkg.version '0.65.0'
  pkg.md5sum '1c2828a4a83daf659c7e0487852588d5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
