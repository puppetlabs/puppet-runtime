component 'rubygem-erubi' do |pkg, settings, platform|
  pkg.version '1.12.0'
  pkg.md5sum '92fa9ac9f48cce608153108e327d020d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
