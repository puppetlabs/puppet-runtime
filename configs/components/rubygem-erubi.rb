component 'rubygem-erubi' do |pkg, settings, platform|
  pkg.version '1.10.0'
  pkg.md5sum 'e8111998389faf7fb877012fba4485ff'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
