component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.2.0'
  pkg.md5sum '28fa3ba73d0707377370b08733e7d016'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
