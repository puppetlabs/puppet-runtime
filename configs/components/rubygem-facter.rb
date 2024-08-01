component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.8.0'
  pkg.md5sum 'fdcdbd04cb3aaee32c39e79a5ea05478'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end