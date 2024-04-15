component 'rubygem-nkf' do |pkg, settings, platform|
  pkg.version '0.2.0'
  pkg.md5sum '7a0af896fa45703c594cf0535096a8ed'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
