component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.8.1'
  pkg.md5sum '4a1b51862f64f7f60599a5551685bf1e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
