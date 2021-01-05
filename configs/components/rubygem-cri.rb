component 'rubygem-cri' do |pkg, settings, platform|
  pkg.version '2.15.11'
  pkg.md5sum '98e0ce55d289f9aed97ee11c5ba83010'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
