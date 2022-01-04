component 'rubygem-webrick' do |pkg, settings, platform|
  pkg.version '1.7.0'
  pkg.md5sum '00739c2de1b9986f8db84355ac0da787'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
