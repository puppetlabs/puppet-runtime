component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.25.1'
  pkg.version version

  case version
  when '7.13.1'
    pkg.md5sum 'd776b039312b67e00f1b3b64790efebe'
  when '6.25.1'
    pkg.md5sum '84c2c31b281152729476dfe04fd3a101'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
