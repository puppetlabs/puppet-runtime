component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.6.0'
  pkg.md5sum 'f8df1239905409aad2c5142495003721'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
