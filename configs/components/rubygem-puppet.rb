component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use 6.20.0 by default:
  version = settings[:rubygem_puppet_version] || '6.23.0'
  pkg.version version

  case version
  when '7.7.0'
    pkg.md5sum '81cfcab6f6998bf7cfbcf0c91a72a469'
  when '6.23.0'
    pkg.md5sum '10dbdce584a286bed95835420e2fba48'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
