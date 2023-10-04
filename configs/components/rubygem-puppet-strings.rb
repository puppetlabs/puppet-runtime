component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '4.1.0'
  pkg.md5sum 'd8259d8a9144757f4e78f118b59e2681'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

