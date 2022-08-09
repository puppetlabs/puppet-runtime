component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '1.10.1'
  pkg.md5sum '4fe172f807c117441cc5d38d8b49a526'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
