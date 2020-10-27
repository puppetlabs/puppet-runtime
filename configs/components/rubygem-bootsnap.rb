component 'rubygem-bootsnap' do |pkg, settings, platform|
  pkg.version '1.7.2'
  pkg.md5sum '3c16afcb468f7e98c9d5e93f8db1b29f'

  pkg.build_requires 'rubygem-msgpack'
  
  instance_eval File.read('configs/components/_base-rubygem-native-extension.rb')
end
