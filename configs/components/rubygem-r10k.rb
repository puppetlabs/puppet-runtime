component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.3.0'
  pkg.md5sum 'f11b1732a64214a6431ff96e3b3eafd1'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
