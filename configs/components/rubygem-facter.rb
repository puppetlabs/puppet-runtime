component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.51'
  pkg.md5sum 'd8088a901f508ffd8652508500a94924'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
