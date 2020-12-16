component 'rubygem-paint' do |pkg, settings, platform|
  pkg.version '2.2.1'
  pkg.md5sum 'c9f60207d67262cbb55ce12d100cf3f2'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
