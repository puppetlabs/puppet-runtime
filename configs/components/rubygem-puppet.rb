component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.12.0'
  pkg.md5sum 'edf1aba62615fa47c7ba04e7afdeef59'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
