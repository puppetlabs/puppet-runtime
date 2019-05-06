component 'rubygem-winrm' do |pkg, settings, platform|
  pkg.version '2.3.2'
  pkg.md5sum '543925c13da3c3e46bf489a8b4795322'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
