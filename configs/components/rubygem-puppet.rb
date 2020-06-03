component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.16.0'
  pkg.md5sum 'ed0c92a2bbeb5247bff7e33fb85af873'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
