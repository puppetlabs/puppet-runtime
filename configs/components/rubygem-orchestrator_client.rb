component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.version '0.5.1'
  pkg.md5sum 'c1cf6fb6d4613c2ec1a3267b90e254b6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
