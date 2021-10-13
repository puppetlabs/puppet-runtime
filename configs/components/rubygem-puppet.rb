component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.24.0'
  pkg.version version

  case version
  when '7.12.0'
    pkg.md5sum '47cacbe6ac520e817ee5761a769916cc'
  when '6.24.0'
    pkg.md5sum 'af6bbabf8ba8b11184f3ff143d4217ac'
  when '6.24.0.167.g62c2cba'
    pkg.md5sum 'e6b598b24e68d6e97d071757559d44bf'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
  if version == '6.24.0.167.g62c2cba'
    pkg.url("#{settings[:artifactory_url]}/rubygems/gems/puppet-#{version}.gem")
  end
end
