component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '2.7.0'
  pkg.md5sum '75c44c7202e916986aa9db30a0b13f68'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

