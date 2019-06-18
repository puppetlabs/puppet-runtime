component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  pkg.version '3.1.0'
  pkg.md5sum '51fd0abb35a8039341d8131598f845f5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end