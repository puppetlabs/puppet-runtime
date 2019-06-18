component 'rubygem-winrm-fs' do |pkg, settings, platform|
  pkg.version '1.3.2'
  pkg.md5sum '8fd540c29ff0a9f32f62e2ad4d4db0f3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
