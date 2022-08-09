component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.28.0'
  pkg.version version

  case version
  when '7.18.0'
    pkg.md5sum '16e019b09d29592cdf43dbea72e14e1c'
  when '6.28.0'
    pkg.md5sum '31520d986869f9362c88c7d6a4a5c103'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
