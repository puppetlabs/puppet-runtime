component 'rubygem-puppet_forge' do |pkg, settings, platform|
  pkg.version '2.3.2'
  pkg.md5sum '13452e071eea03546e99e5a33c0092e5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
