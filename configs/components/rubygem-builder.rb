component 'rubygem-builder' do |pkg, settings, platform|
  pkg.version '3.3.0'
  pkg.md5sum '3048be022111b96f47bb17c34c67dbc7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
