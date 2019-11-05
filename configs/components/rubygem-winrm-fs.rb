component 'rubygem-winrm-fs' do |pkg, settings, platform|
  pkg.version '1.3.3'
  pkg.md5sum '43252a70db9727a47c840e40e0f75c26'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
