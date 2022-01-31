component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.14.0'
  pkg.md5sum '2212361e88a55df1b41c6704c91c256f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
