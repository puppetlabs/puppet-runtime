component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.24.0'
  pkg.version version

  case version
  when '7.10.0'
    pkg.md5sum '801e1945b1c483d1d5a4cb9b1caf7578'
  when '6.24.0'
    pkg.md5sum 'af6bbabf8ba8b11184f3ff143d4217ac'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
