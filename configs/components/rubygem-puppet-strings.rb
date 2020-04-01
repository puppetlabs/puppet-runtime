component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '2.4.0'
  pkg.md5sum '62aa815177bd9a1c3808faccbb5ed1b8'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

