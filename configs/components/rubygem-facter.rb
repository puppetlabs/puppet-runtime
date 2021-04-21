component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.1.1'
  pkg.md5sum '4efbab3bd854c2bff992b641f08f2712'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
