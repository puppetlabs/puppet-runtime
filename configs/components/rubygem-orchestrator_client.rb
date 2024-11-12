component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.version '0.7.1'
  pkg.md5sum '177686e31c134ae9fdee25ba8c0404a0'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end