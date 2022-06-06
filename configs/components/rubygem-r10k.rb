component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.15.0'
  pkg.md5sum 'e8ed305a7f2aa130c8be2e42a397a923'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
