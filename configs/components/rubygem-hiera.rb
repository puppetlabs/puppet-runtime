component 'rubygem-hiera' do |pkg, settings, platform|
  pkg.version '3.6.0'
  pkg.md5sum 'c1975a0cad3df4ba6cf64d07be219f75'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
