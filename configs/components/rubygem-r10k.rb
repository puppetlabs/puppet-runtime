component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.3.3'
  pkg.md5sum '58876681869c3017d091acfe3c3e195f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
