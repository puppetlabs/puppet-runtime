component 'rubygem-rubyzip' do |pkg, settings, platform|
  pkg.version '2.3.2'
  pkg.md5sum 'd8396c7f2cefde071353f2a09ee7d2f6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
