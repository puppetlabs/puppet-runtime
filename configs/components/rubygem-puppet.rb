component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.14.0'
  pkg.md5sum '229ebd984b38668c8ac16b22d03a1f2a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
