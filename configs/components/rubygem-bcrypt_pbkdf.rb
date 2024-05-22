component 'rubygem-bcrypt_pbkdf' do |pkg, _settings, _platform|
  pkg.version '1.1.1'
  pkg.md5sum '3efcbfd0289e0783513b738823a2deba'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
