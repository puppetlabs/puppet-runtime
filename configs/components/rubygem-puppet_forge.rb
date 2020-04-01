component 'rubygem-puppet_forge' do |pkg, settings, platform|
  pkg.version '2.3.4'
  pkg.md5sum '28a74b4f97fbd3ce8ee184ad81317beb'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
