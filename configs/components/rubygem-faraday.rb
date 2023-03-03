component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '1.10.3'
  pkg.md5sum 'c7b56130721c0b055c071bec593e2446'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
