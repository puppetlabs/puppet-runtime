component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.2.6'
  pkg.md5sum '4240884cf98b877aaafc4408c10efe2c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
