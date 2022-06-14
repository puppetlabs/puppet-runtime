component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '1.10.0'
  pkg.md5sum '3a6d2c5453421b00cfc39d717823e616'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
