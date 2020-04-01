component 'rubygem-bindata' do |pkg, settings, platform|
  pkg.version '2.4.7'
  pkg.md5sum '5803f4525dc4e2687b97aa37f0602a08'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
