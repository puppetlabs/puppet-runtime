component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.version '0.5.4'
  pkg.md5sum 'f686c10f9dfd17b0296669fc5cbb91bd'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
