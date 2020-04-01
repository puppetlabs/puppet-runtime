component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '1.8.12'
  pkg.md5sum '3e4412252e4574bbf86dd9e85a318f22'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
