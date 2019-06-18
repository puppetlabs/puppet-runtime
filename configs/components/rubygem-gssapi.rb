component 'rubygem-gssapi' do |pkg, settings, platform|
  pkg.version '1.3.0'
  pkg.md5sum 'df2210cf9fd6e7fe90756c752de2c0f4'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
