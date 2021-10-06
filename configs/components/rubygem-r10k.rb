component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.12.1'
  pkg.md5sum '9710edbb5b2ee0992396b448b4920fb6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
