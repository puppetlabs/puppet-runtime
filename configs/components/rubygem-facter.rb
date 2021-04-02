component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.52'
  pkg.md5sum '506d3387aab8140ae5c4b297a392c27f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
