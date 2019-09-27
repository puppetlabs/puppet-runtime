component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.version '0.4.3'
  pkg.md5sum '603e715895fcf25d80fdccd0b3a4b22f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
