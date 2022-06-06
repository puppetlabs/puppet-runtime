component 'rubygem-windows_error' do |pkg, settings, platform|
  pkg.version '0.1.4'
  pkg.md5sum '0e84bff54c220c09afd1706420ee439a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
