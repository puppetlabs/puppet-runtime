component 'rubygem-excon' do |pkg, settings, platform|
  pkg.version '0.64.0'
  pkg.md5sum 'd0724dd004539e40a78bffdc25224640'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
