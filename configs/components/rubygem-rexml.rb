component 'rubygem-rexml' do |pkg, settings, platform|
  pkg.version '3.2.6'
  pkg.md5sum 'a57288ae5afed07dd08c9f1302da7b25'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
