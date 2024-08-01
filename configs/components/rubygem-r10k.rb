component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.16.2'
  pkg.sha256sum '9775a726ba94a543bf49952b10dcd23690a54f5d2a361746b78b1292abe32eb9'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
