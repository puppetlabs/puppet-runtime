component 'rubygem-thor' do |pkg, settings, platform|
  pkg.version '1.0.1'
  pkg.md5sum '052eb36fd3e522331af98449556991dc'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
