component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.9.0'
  pkg.md5sum '2433eb12ad5c422baabd43987c7ca1a4'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
