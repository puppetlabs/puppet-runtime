component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '2.5.0'
  pkg.md5sum 'e811763411ce0c36ffcb40aa5ca44212'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

