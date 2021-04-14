component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.1.0'
  pkg.md5sum '508055b1781d3c694902ca876022dc73'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
