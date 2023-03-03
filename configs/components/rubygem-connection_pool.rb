component 'rubygem-connection_pool' do |pkg, settings, platform|
  pkg.version '2.3.0'
  pkg.md5sum 'bbbbc0e38de79db9f0cb2907c81204a4'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
