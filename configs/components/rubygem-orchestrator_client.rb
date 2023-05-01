component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.version '0.7.0'
  pkg.md5sum '03fb7c2fb2d8d407b638e31761bc0d92'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end