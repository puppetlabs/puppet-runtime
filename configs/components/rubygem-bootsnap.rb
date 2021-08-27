component 'rubygem-bootsnap' do |pkg, settings, platform|
  pkg.version '1.8.0'
  pkg.md5sum 'c5cad76ae2201d2f7da394f665df4dee'

  pkg.build_requires 'rubygem-msgpack'
  
  instance_eval File.read('configs/components/_base-rubygem-native-extension.rb')
end
