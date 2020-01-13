component 'rubygem-sys-filesystem' do |pkg, settings, platform|
  pkg.version '1.3.2'
  pkg.md5sum '3cab54e4c93e483553f21d1080e5f2aa'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
