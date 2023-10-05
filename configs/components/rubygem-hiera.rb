component 'rubygem-hiera' do |pkg, settings, platform|
  pkg.version '3.12.0'
  pkg.md5sum '67249a25571c9ee83cdb68579faf3f0d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
