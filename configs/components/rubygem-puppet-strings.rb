component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '2.9.0'
  pkg.md5sum '3016a0b9cc1cc94a35e0c4869d8b13ec'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

