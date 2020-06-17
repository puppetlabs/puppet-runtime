component 'rubygem-connection_pool' do |pkg, settings, platform|
  pkg.version '2.2.3'
  pkg.md5sum '1ccc96dc7feb55947fe7ec6799ba19b3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
