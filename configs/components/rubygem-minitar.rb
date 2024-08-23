component 'rubygem-minitar' do |pkg, settings, platform|
  pkg.version '0.12'
  pkg.md5sum '359d7e38c9afefb82e97a7f301e8c98a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end