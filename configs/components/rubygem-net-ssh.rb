component "rubygem-net-ssh" do |pkg, settings, platform|
  # Projects may define a :rubygem_net_ssh_version setting, or we use 4.2.0 by default:
  version = settings[:rubygem_net_ssh_version] || '4.2.0'
  pkg.version version

  case version
  when "7.2.3"
    pkg.md5sum "be25f70538cb8dcde68d924f001d75df"
  when "6.1.0"
    pkg.md5sum "383afadb1bd66a458a5d8d2d60736b3d"
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
