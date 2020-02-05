component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.4.0'
  pkg.md5sum '03068b228381f7a8f9bf74cacaedda57'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
