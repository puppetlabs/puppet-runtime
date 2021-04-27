component 'rubygem-thor' do |pkg, settings, platform|
  pkg.version '1.1.0'
  pkg.md5sum '0d39b5be66778612f3233253e5b78ae6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
