component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.27.0'
  pkg.version version

  case version
  when '7.17.0'
    pkg.md5sum '6d3090fed500e5efd9192f6383c5029a'
  when '6.27.0'
    pkg.md5sum 'b0c17ab1076e47efa6ea4e9d1cdbff2b'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
