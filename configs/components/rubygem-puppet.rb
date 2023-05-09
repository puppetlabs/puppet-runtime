component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.28.0'
  pkg.version version

  case version
  when '8.0.1'
    pkg.md5sum '7e87d988e485c0f0c3d6ef76bd39409d'
  when '7.24.0'
    pkg.md5sum '3e996d5ceb0af826c95484494ad8a9a4'
  when '6.28.0'
    pkg.md5sum '31520d986869f9362c88c7d6a4a5c103'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end