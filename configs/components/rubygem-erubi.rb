component 'rubygem-erubi' do |pkg, settings, platform|
  pkg.version '1.11.0'
  pkg.md5sum '42f1f27ca9b70754f1eee09b761d5672'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
