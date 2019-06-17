component 'rubygem-rubyzip' do |pkg, settings, platform|
  pkg.version '1.2.3'
  pkg.md5sum 'be7912f85c02af68df2e7bba1798e981'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
