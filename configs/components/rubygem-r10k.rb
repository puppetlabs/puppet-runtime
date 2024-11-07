component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '4.1.0'
  pkg.sha256sum '64e5b9e1a6cbb4006c96477d8c34ce589fe1c278117311f452d9f30b9cc86e4c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
