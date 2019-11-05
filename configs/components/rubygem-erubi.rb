component 'rubygem-erubi' do |pkg, settings, platform|
  pkg.version '1.9.0'
  pkg.md5sum '9a1e6439fae69dd1133fbb76c96797db'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
