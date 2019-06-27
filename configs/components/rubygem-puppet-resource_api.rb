component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '1.8.4'
  pkg.md5sum 'bc43e38b0a90638c959994f0223744f6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
