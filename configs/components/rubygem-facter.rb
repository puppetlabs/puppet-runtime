component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.2.3'
  pkg.md5sum 'af11344fd0cd8b09c9fcffcca0c278ed'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
