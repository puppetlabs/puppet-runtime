component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.6.0'
  pkg.md5sum 'bc80b8ff8b92758d24fdc50f82121ff6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
