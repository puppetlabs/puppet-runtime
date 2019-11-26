component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '2.3.1'
  pkg.md5sum '8f026b9e089e03571a3be59e25b137fd'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

