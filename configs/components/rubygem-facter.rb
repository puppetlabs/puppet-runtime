component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.49'
  pkg.md5sum '56266dd1b2418bc26a7a0f12fc9774cc'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
