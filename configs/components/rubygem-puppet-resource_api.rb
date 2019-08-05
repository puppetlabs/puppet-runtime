component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '1.8.6'
  pkg.md5sum 'f07ab551529b968230e6b8de07ae84d7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
