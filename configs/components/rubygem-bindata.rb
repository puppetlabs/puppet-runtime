component 'rubygem-bindata' do |pkg, settings, platform|
  pkg.version '2.4.10'
  pkg.md5sum 'cf67b5b16c307139691d6cbec0c8c2ef'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
