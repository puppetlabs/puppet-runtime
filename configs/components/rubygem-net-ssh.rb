component "rubygem-net-ssh" do |pkg, settings, platform|
  # Projects may define a :rubygem_net_ssh_version setting, or we use 4.2.0 by default:
  version = settings[:rubygem_net_ssh_version] || '4.2.0'
  pkg.version version

  case version
  when "5.1.0"
    pkg.md5sum "b5cc4ab9a79e8a1b07f729489f368129"
  when "4.2.0"
    pkg.md5sum "fec5b151d84110b95ec0056017804491"
  when "4.1.0"
    pkg.md5sum "6af1ff8c42a07b11203058c9b74cbaef"
  else
    raise "rubygem-net-ssh version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.url "https://rubygems.org/downloads/net-ssh-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/net-ssh-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} net-ssh-#{pkg.get_version}.gem"]
  end
end
