component 'rubygem-paint' do |pkg, settings, platform|
  pkg.version '2.3.0'
  pkg.md5sum '5f51716cec1f4fe3db8ba1880f9fc875'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
