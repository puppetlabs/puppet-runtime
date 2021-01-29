component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '2.6.0'
  pkg.md5sum '69557c69e8ed2675b57fc18e24d6e144'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

