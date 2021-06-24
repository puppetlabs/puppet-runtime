component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.2.1'
  pkg.md5sum '404fda5456d8806611eac9778b001536'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
