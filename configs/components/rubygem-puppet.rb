component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.25.0'
  pkg.version version

  case version
  when '7.12.0'
    pkg.md5sum '47cacbe6ac520e817ee5761a769916cc'
  when '6.25.0'
    pkg.md5sum 'c0b48b70a9faafd7449434b60c8428ec'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
