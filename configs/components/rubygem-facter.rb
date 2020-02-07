component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '2.5.7'
  pkg.md5sum '13b29436cc50caa7a8eeef8c4e1c8d36'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
