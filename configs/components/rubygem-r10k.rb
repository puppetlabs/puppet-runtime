component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.7.0'
  pkg.md5sum 'd1e02ba57654feb81eb60b593cf87301'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
