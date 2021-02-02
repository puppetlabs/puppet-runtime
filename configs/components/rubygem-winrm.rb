component 'rubygem-winrm' do |pkg, settings, platform|
  pkg.version '2.3.6'
  pkg.md5sum 'a99f8e81343f61caa441eb1397a1c6ae'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
