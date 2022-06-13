component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.version '0.6.1'
  pkg.md5sum 'a556e34451e9985a518230d6d79e90a3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
