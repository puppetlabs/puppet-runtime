component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.15.3'
  pkg.sha256sum '2b9cbdab2d52ae6572043978c71cc8b925d937253fa3e7c04613b914ee59d4b2'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
