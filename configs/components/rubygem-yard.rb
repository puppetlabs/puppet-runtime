component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.24'
  pkg.md5sum '413197ed3b0a0d8c791d2111ea3a1bd0'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

