component 'rubygem-ed25519' do |pkg, _settings, _platform|
  pkg.version '1.3.0'
  pkg.md5sum 'd810e3aa82d0a0fb9b9d7ca6146121e4'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
