component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.13'
  pkg.md5sum 'b75e5f9a0f13bfeec9c7e7b29a7e6625'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
