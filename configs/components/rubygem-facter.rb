component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.7.0'
  pkg.md5sum 'b77bcd4ed8ebf713717a89014b835830'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end