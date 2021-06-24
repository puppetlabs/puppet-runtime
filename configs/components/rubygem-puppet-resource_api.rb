component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '1.8.14'
  pkg.md5sum 'aee660a8398fc1c4dff2154eeb8b5975'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
