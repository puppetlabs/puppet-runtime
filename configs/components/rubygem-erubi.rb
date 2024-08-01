component 'rubygem-erubi' do |pkg, settings, platform|
  pkg.version '1.13.0'
  pkg.md5sum 'ebcea152a605001af22d9899a57087f7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
