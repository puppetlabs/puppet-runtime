component 'rubygem-faraday-rack' do |pkg, settings, platform|
  pkg.version '1.0.0'
  pkg.md5sum 'e1f15e1a8e72e3d38c7973550e11925e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
