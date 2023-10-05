component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.34'
  pkg.md5sum '9c8530eaaf9acf6fd32ee4b51119e46a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

