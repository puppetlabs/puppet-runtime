component 'rubygem-win32-eventlog' do |pkg, settings, platform|
  pkg.version '0.6.2'
  pkg.md5sum '89b2e7dd8cc599168fa444e73c014c3d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
