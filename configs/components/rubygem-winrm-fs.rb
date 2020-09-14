component 'rubygem-winrm-fs' do |pkg, settings, platform|
  pkg.version '1.3.5'
  pkg.md5sum 'dcde27a3aff684b8277c069cd4b2efe7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
