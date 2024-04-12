component 'rubygem-puppet-strings' do |pkg, settings, platform|
  # 2021.7.x LTS has a jruby that does not work with puppet-strings
  # version 4.y. The 4 series requires ruby >= 2.7
  # Default to 4.x sereies but allow it to be configuratble by project.
  version = settings[:rubygem_puppet_strings_version] || '4.1.2'
  pkg.version(version)

  case version
  when '3.0.1'
    pkg.md5sum '7c9a8936509a0434c39975a75197472c'
  when '4.1.2'
    pkg.md5sum 'e19f3fdc60692df346d1a348ab9facee'
  else
    raise "Invalid version #{version} for rubygem-puppet-strings; Cannot continue."
  end
  instance_eval File.read('configs/components/_base-rubygem.rb')
end

