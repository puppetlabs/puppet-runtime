component 'rubygem-winrm' do |pkg, settings, platform|
  pkg.version '2.3.4'
  pkg.md5sum 'c2e7a4a762929ac78a6c33543be53d90'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
