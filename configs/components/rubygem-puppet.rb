component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.15.0'
  pkg.md5sum '4fc59e4be69e9526921899b5e0e7c1ff'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
