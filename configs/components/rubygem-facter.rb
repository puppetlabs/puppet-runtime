component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '2.5.5'
  pkg.md5sum '489a09a5acb6942fb020d363954eebe7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
