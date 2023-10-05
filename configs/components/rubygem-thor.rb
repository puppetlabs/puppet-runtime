component 'rubygem-thor' do |pkg, settings, platform|
  pkg.version '1.2.2'
  pkg.md5sum 'cafae723e9fc9ab9bc834471cee2a906'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
