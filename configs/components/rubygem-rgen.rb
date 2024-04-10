component 'rubygem-rgen' do |pkg, settings, platform|
  pkg.version '0.9.1'
  pkg.md5sum 'fafb97eeb3ea5385f70b2ff83af6d8b6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
