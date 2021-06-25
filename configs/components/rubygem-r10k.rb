component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.9.2'
  pkg.md5sum 'a5a29f904dbbf2802a06304614e16bf2'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
