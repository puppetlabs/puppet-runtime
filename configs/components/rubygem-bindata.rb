component 'rubygem-bindata' do |pkg, settings, platform|
  pkg.version '2.4.8'
  pkg.md5sum '80a3ba1ffdbf020da0efb8c492c67a3a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
