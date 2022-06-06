component 'rubygem-logging' do |pkg, settings, platform|
  pkg.version '2.3.1'
  pkg.md5sum '864dbb25dcaa5fe55c39df3e599149a1'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
