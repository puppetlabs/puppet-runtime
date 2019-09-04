component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '2.5.6'
  pkg.md5sum '18901a7b8c5cc5bc09e80794035d1f31'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
