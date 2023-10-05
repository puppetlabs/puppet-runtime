component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.5.0'
  pkg.md5sum 'b10500668a69db77ddb65907be2bd908'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end