component 'rubygem-logging' do |pkg, settings, platform|
  pkg.version '2.3.0'
  pkg.md5sum 'bd8cbc98f36af473775cb7b748b0dcbf'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
