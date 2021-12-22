component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.27'
  pkg.md5sum 'ed897c4c7e09714d376a359e5e52d70b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

