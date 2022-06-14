component 'rubygem-puppet_forge' do |pkg, settings, platform|
  pkg.version '3.2.0'
  pkg.md5sum '501d5f9f742007504d0d60ce6cf0c27f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
