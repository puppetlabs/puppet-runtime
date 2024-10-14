component 'rubygem-faraday-net_http' do |pkg, settings, platform|
  version = settings[:rubygem_faraday_net_http_version] || '1.0.2'

  case version
  when '1.0.2'
    pkg.version '1.0.2'
    pkg.md5sum 'b8e560b8cd7c008a7fd1686143428337'
  when '3.3.0'
    pkg.version '3.3.0'
    pkg.md5sum '7e6378aaa271587dd4109795c0a05769'
  else
    raise "rubygem-faraday-net_http version #{version} is not supported"
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
