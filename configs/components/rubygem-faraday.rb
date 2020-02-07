component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '0.14.0'
  pkg.md5sum '9b11daa6e4a18bddeb7de9a4bc9e0315'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
