component "rubygem-net-ssh" do |pkg, settings, platform|
  # Projects may define a :rubygem_net_ssh_version setting, or we use 4.2.0 by default:
  version = settings[:rubygem_net_ssh_version] || '4.2.0'
  pkg.version version

  case version
  when "6.0.2"
    pkg.md5sum "20d6098cf1139c66c26d53f0c42456b3"
  when "5.2.0"
    pkg.md5sum "341114b3bf34257abd3b11bd16b0c99d"
  when "4.2.0"
    pkg.md5sum "fec5b151d84110b95ec0056017804491"
  when "4.1.0"
    pkg.md5sum "6af1ff8c42a07b11203058c9b74cbaef"
  else
    raise "rubygem-net-ssh version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
