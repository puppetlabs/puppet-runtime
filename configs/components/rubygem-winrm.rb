component 'rubygem-winrm' do |pkg, settings, platform|
  version = settings[:rubygem_winrm_version] || '2.3.6'
  pkg.version version

  case version
  when '2.3.6'
    pkg.md5sum 'a99f8e81343f61caa441eb1397a1c6ae'
  when '2.3.9'
    pkg.md5sum '3ee81372528048b8305334ab6f36b4e9'
  else
    raise "rubygem-winrm #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
