component 'rubygem-rexml' do |pkg, settings, platform|
  pkg.version '3.2.5'
  pkg.md5sum 'e8685a8e5a4b6bb8eb810ea1477a99dc'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
