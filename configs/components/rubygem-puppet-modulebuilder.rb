component 'rubygem-puppet-modulebuilder' do |pkg, settings, platform|
  pkg.version '1.0.0'
  pkg.sha256sum 'cf9d9e8146aeae780b7c61f30847a4cb631debcf708c21281976d5ed79820cfd'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
