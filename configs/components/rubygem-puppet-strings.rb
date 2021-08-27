component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '2.8.0'
  pkg.md5sum '35d27e52d4604955ed7fe7d5ecbd637d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

