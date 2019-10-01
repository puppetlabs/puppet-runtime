component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '1.8.7'
  pkg.md5sum '1e592e960934d59cacc7d3b443074a8a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
