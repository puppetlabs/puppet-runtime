component 'rubygem-gssapi' do |pkg, settings, platform|
  pkg.version '1.3.1'
  pkg.md5sum '4bd2df09d8e0ab4c6d2e1828c344eba1'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
