component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  pkg.version '1.1.7'
  pkg.md5sum '3558ccacd1371bf34a43ba82b79bc5cc'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
