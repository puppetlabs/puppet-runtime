component 'rubygem-bundler' do |pkg, settings, platform|
  pkg.version '1.16.1'
  pkg.md5sum '250ac082e64245f439c76b2c641e85b5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
