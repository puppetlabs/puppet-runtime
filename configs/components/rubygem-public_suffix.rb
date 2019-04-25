component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  pkg.version '3.0.3'
  pkg.md5sum 'ed3fcbcfd26093918e0afcc083480403'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end