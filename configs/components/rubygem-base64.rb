component 'rubygem-bas64' do |pkg, settings, platform|
  pkg.version '0.2.0'
  pkg.md5sum 'fe02f4347a5846f79f4d4615edababd3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
