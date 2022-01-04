component 'rubygem-hiera' do |pkg, settings, platform|
  pkg.version '3.8.0'
  pkg.md5sum 'a3f2e2fb2c31fdcdd18b2f881988a19e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
