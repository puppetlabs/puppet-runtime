component 'rubygem-cri' do |pkg, settings, platform|
  pkg.version '2.15.10'
  pkg.md5sum '5f74856e3a41ba0f9822bb586470838d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
