component 'rubygem-minitar' do |pkg, settings, platform|
  pkg.version '0.12.1'
  pkg.md5sum '975dee1dadeb26a2a01105802c3172ab'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end