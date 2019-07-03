component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  pkg.version '3.1.1'
  pkg.md5sum 'df5c3a90582565bb91b035c771a58075'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end