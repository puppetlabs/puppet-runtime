component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.16.0'
  pkg.sha256sum 'b149769db941e93494e2748229fc247c34a8509261209f640a57e16e40560ba5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
