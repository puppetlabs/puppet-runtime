component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.version '0.5.2'
  pkg.md5sum '97b3f0597a4fddf0ce88783c919748fc'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
