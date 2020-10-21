component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.19.0'
  pkg.md5sum 'f2b4f1c523bbfdf5632a741d5657af11'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
