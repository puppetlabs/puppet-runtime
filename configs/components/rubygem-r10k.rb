component 'rubygem-r10k' do |pkg, settings, platform|
  version = settings[:rubygem_r10k_version] || '3.16.2'

  case version
  when '3.16.2'
    pkg.version '3.16.2'
    pkg.sha256sum '9775a726ba94a543bf49952b10dcd23690a54f5d2a361746b78b1292abe32eb9'
  when '4.1.0'
    pkg.version '4.1.0'
    pkg.sha256sum '64e5b9e1a6cbb4006c96477d8c34ce589fe1c278117311f452d9f30b9cc86e4c'
  else
    raise "rubygem-r10k version #{version} is not supported"
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
