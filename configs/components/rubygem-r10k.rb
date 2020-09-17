component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.5.2'
  pkg.md5sum '14625f78d0157380a0050e2acb5ed7a8'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
