component 'rubygem-winrm' do |pkg, settings, platform|
  pkg.version '2.3.3'
  pkg.md5sum 'fd9cd65774bb1be1d05ba88f5a4f3986'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
