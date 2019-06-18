component 'rubygem-hiera' do |pkg, settings, platform|
  pkg.version '3.5.0'
  pkg.md5sum '9faba256f127996825b2a73a33b62982'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
