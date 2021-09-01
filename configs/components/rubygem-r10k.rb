component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.11.0'
  pkg.md5sum 'bf5790e7d6f4c5f438358c2dca06a62d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
