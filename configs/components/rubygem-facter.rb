component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.14'
  pkg.md5sum '98ab3184789da98bd5e053555f7807ba'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
