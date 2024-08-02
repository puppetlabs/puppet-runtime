component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  pkg.version '5.1.1'
  pkg.md5sum '0895274ce1ffdadffcd979ced832b851'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
