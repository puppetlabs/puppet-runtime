component 'rubygem-builder' do |pkg, settings, platform|
  pkg.version '3.2.4'
  pkg.md5sum '3f97760c1802f23c7ddd5e789eba21fa'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
