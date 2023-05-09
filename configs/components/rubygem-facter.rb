component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.4.0'
  pkg.md5sum '3fc0af68842912b7b11da02b329b88ff'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

