component 'rubygem-net-http-persistent' do |pkg, settings, platform|
  pkg.version '4.0.2'
  pkg.md5sum 'fe6e3e668a45be1f78886ef48ca4137b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
