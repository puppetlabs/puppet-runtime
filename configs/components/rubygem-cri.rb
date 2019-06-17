component 'rubygem-cri' do |pkg, settings, platform|
  pkg.version '2.15.6'
  pkg.md5sum 'ece5235f0dc2e0e20cc7c7b4a07437b7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
