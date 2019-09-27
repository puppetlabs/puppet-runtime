component 'rubygem-rubyzip' do |pkg, settings, platform|
  pkg.version '1.3.0'
  pkg.md5sum '73adcf1825fe53847d6c4b52c5f05722'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
