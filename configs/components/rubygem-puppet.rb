component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use 6.20.0 by default:
  version = settings[:rubygem_puppet_version] || '6.20.0'
  pkg.version version

  case version
  when '7.4.1'
    pkg.md5sum 'eb18488e61f43bf3cf7ee94128c469e6'
  when '6.20.0'
    pkg.md5sum 'b1a6f244663f04075bafb1d36eede31c'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
