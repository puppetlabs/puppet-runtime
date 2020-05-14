component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.21'
  pkg.md5sum '1122f4cec8a7151c2d8a238ad34acf15'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
