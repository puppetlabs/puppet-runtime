component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.38'
  pkg.md5sum '3c518707beab8810cfcbe5129d77447f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
