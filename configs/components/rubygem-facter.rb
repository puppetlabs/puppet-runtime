component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.2.11'
  pkg.md5sum '5a387c10f5917d88b46cacd5da2de6f1'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
