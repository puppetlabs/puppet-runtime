component 'rubygem-logging' do |pkg, settings, platform|
  pkg.version '2.4.0'
  pkg.md5sum '8953eab63c979ecdac781cbf0da1872a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
