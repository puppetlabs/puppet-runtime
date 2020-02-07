component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  pkg.version '4.0.3'
  pkg.md5sum '962527905a37e6f128f81978443bd56a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end