component 'rubygem-rubyntlm' do |pkg, settings, platform|
  pkg.version '0.6.3'
  pkg.md5sum 'e1f7477acf8a7d3effb2a3fb931aa84c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end