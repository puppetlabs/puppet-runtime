component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '3.0.1'
  pkg.md5sum '7c9a8936509a0434c39975a75197472c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

