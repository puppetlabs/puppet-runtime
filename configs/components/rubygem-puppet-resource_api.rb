component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '1.8.13'
  pkg.md5sum '3f6edad4f7a03713ff20d8ae0378e895'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
