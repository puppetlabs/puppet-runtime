component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version "6.19.1"
  pkg.md5sum '8d68e677e6ba88e46eb00699dcd4930b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
