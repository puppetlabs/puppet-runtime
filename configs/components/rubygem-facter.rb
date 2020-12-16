component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.47'
  pkg.md5sum '30577ad8e59fb7d6c09dd53115b2a15d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
