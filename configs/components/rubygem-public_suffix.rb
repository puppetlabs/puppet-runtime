component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  pkg.version '4.0.6'
  pkg.md5sum 'a8709e7242bf05183a56e10fca4d0e9d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
