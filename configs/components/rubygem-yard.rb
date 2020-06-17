component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.25'
  pkg.md5sum 'b987bbe40d5424ab115e132312d04e1c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

