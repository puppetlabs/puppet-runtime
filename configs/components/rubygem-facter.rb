component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.3.0'
  pkg.md5sum 'aef369eddbda0a53790b07ceea30449e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
