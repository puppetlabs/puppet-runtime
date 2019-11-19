component 'rubygem-rubyzip' do |pkg, settings, platform|
  pkg.version '2.0.0'
  pkg.md5sum 'c0746ad116eeca88c441819cfb24e446'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
