component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.4.1'
  pkg.md5sum '0dec8b5602673ef8076166d9407bb77e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
