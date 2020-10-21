component 'rubygem-winrm' do |pkg, settings, platform|
  pkg.version '2.3.5'
  pkg.md5sum '836e1bb6fb6ebae9b87a7333db2bfce9'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
