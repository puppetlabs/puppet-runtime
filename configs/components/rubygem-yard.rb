component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.28'
  pkg.md5sum 'd5ac32134ef09cb6194a0371b863c7c1'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

