component 'rubygem-ruby_smb' do |pkg, settings, platform|
  pkg.version '1.1.0'
  pkg.md5sum 'f926be4cb045b5984d02dc10e2b240ca'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
