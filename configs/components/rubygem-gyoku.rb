component 'rubygem-gyoku' do |pkg, settings, platform|
  pkg.version '1.4.0'
  pkg.md5sum 'fecd9488be9b07a250349e9bbe048e5f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
