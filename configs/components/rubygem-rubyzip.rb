component 'rubygem-rubyzip' do |pkg, settings, platform|
  pkg.version '2.3.0'
  pkg.md5sum '3a836c8f901f875882dde4e58178bbf8'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
