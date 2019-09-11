component 'rubygem-minitar' do |pkg, settings, platform|
  pkg.version '0.9'
  pkg.md5sum '4ab2c278183c9a83f3ad97066c381d84'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end