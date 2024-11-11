component 'rubygem-faraday-net_http_persistent' do |pkg, settings, platform|
  version = settings[:rubygem_faraday_net_http_persistent_version] || '1.2.0'

  case version
  when '1.2.0'
    pkg.version '1.2.0'
    pkg.md5sum 'e13bafd2297cbf703e0385e142c9ce62'
  when '2.3.0'
    pkg.version '2.3.0'
    pkg.md5sum 'b8003472ed288c44021dcfed574353b2' 
  else
    raise "rubygem-faraday-net_http_persistent version #{version} is not supported"
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
