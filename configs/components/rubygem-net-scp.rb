component 'rubygem-net-scp' do |pkg, settings, platform|
  pkg.version '4.0.0'
  pkg.md5sum 'a97dcd90f88ec481fdf81b53cfc93285'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
