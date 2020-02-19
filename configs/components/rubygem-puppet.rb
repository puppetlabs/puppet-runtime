component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.13.0'
  pkg.md5sum 'c1981c24c9d9733abf602504891682e5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
