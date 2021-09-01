component 'rubygem-bcrypt_pbkdf' do |pkg, _settings, _platform|
  pkg.version '1.1.0'
  pkg.md5sum '778d710cbb4ce21e81b73385b9743d37'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
