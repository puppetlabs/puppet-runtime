component 'rubygem-rgen' do |pkg, settings, platform|
  pkg.version '0.9.0'
  pkg.md5sum 'c0c6ae4351cf7d1deca2ab052e87d7ab'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

