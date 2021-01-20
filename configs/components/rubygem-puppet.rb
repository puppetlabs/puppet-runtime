component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version "6.20.0"
  pkg.md5sum 'b1a6f244663f04075bafb1d36eede31c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
