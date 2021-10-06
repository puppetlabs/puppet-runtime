component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.2.5'
  pkg.md5sum '2f3f8d02a4ec422e78e484d3a413548f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
