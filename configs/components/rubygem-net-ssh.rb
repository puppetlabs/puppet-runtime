component "rubygem-net-ssh" do |pkg, settings, platform|
  # Projects may define a :rubygem_net_ssh_version setting, or we use 6.1.0 by default:
  version = settings[:rubygem_net_ssh_version] || '6.1.0'
  if platform.is_cross_compiled? && platform.is_solaris?
    # Building agent-runtime-7.x on Solaris 10/11 SPARC fails with newer versions of net-ssh because those platforms
    # use older (<= 2.1) versions of Ruby for cross-compiling. Pin to 4.2.0, the last version of net-ssh that supports
    # those older Rubies, until we deprecate those platforms.
    version = '4.2.0'
  end
  pkg.version version

  case version
  when "7.2.3"
    pkg.md5sum "be25f70538cb8dcde68d924f001d75df"
  when "6.1.0"
    pkg.md5sum "383afadb1bd66a458a5d8d2d60736b3d"
  when "4.2.0"
    pkg.md5sum "fec5b151d84110b95ec0056017804491"
  else
    raise "rubygem-net-ssh version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
