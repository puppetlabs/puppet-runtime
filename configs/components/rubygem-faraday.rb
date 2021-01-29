component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '0.17.3'
  pkg.md5sum 'aa0eb149651aa6185ca15b31edafb156'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
