component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.9.0'
  pkg.md5sum '8b358a582b028322a5a6c37eb4c8b0e6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
