component 'rubygem-puppet_forge' do |pkg, settings, platform|
  version = settings[:rubygem_puppet_forge_version] || '3.2.0'
  pkg.version version

  case version
  when '3.2.0'
    pkg.version '3.2.0'
    pkg.md5sum '501d5f9f742007504d0d60ce6cf0c27f'
  when '5.0.4'
    pkg.version '5.0.4'
    pkg.md5sum '04a2ca2f027ed41d9142ced587b71bd7'
  else 
    raise "rubygem-puppet_forge version #{version} is not supported"
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
