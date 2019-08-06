component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.7.2'
  pkg.md5sum '4a6a6df3ed7bbf20a5bebd883b83059e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
