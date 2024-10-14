component 'rubygem-faraday' do |pkg, settings, platform|
  version = settings[:rubygem_faraday_version] || '1.10.3'

  case version
  when '1.10.3'
    pkg.version '1.10.3'
    pkg.md5sum 'c7b56130721c0b055c071bec593e2446'
  when '2.12.0'
    pkg.version '2.12.0'
    pkg.md5sum 'c0248b00a32c46b64cd2a172c96409ec' 
  else
    raise "rubygem-faraday version #{version} is not supported"
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
