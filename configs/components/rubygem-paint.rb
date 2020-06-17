component 'rubygem-paint' do |pkg, settings, platform|
  pkg.version '2.2.0'
  pkg.md5sum 'ddd76c92404e3af9abcbae2d26a47a3d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
