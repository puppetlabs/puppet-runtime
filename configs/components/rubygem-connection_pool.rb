component 'rubygem-connection_pool' do |pkg, settings, platform|
  pkg.version '2.2.5'
  pkg.md5sum '498bdfe245ece1c2025fd3727a3dc7e3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
