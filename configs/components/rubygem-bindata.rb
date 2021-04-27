component 'rubygem-bindata' do |pkg, settings, platform|
  pkg.version '2.4.9'
  pkg.md5sum 'a7b78a4d3a97cd97db5e24bd1e9345a2'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
