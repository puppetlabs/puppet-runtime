component 'rubygem-bindata' do |pkg, settings, platform|
  pkg.version '2.4.15'
  pkg.md5sum '55ccdea22d70273b136e573dba9b97cf'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
