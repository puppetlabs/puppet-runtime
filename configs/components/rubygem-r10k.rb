component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.3.1'
  pkg.md5sum 'a46b9774eef3d9c5cd40873afeb047e3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
