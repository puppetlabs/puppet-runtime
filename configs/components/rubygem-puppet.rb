component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.4.2'
  pkg.md5sum '5ba04645242395e10d420cfeb3cd1d49'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
