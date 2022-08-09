component 'rubygem-hiera' do |pkg, settings, platform|
  pkg.version '3.10.0'
  pkg.md5sum '96d4268e1bf8d0716af902f1a01f742a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
