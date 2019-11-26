component 'rubygem-rgen' do |pkg, settings, platform|
  pkg.version '0.8.2'
  pkg.md5sum '89e5cb40cef4f86ec297df14c3073885'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

