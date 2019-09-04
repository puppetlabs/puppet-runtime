component 'rubygem-puppet_forge' do |pkg, settings, platform|
  pkg.version '2.3.0'
  pkg.md5sum '09a24f040971e89ff7afc0d6df8e700e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
