component 'rubygem-webrick' do |pkg, settings, platform|
  pkg.version '1.8.1'
  pkg.md5sum 'e02304c5eafc47d2fb393bba891c538f'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
