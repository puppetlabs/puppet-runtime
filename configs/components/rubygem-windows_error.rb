component 'rubygem-windows_error' do |pkg, settings, platform|
  pkg.version '0.1.5'
  pkg.md5sum 'cb1faeaed0e3b1e4d4ad4e7d1aef76c7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
