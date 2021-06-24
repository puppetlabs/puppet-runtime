component 'rubygem-hiera' do |pkg, settings, platform|
  pkg.version '3.7.0'
  pkg.md5sum '24fd0b1e4f449d09a81bf7688e0dcbde'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
