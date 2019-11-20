component 'rubygem-winrm-fs' do |pkg, settings, platform|
  pkg.version '1.3.4'
  pkg.md5sum 'b4916023c275a4673af9df92755d4848'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
