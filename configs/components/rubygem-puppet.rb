component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.10.1'
  pkg.md5sum 'b9132e1c37b84be4397aa45e9574ad6c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
