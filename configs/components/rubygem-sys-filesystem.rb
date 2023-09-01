component 'rubygem-sys-filesystem' do |pkg, settings, platform|
  pkg.version '1.4.3'
  pkg.sha256sum '390919de89822ad6d3ba3daf694d720be9d83ed95cdf7adf54d4573c98b17421'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
