component 'rubygem-bootsnap' do |pkg, settings, platform|
  pkg.version '1.7.2'
  pkg.md5sum 'dc8b1a2fc84e9a9f3e8934294418692d'

  pkg.build_requires 'rubygem-msgpack'
  
  instance_eval File.read('configs/components/_base-rubygem-native-extension.rb')
end
