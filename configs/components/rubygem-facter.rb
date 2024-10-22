component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.9.0'
  pkg.md5sum '708c7a868ef9622a629480e677674c93'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end