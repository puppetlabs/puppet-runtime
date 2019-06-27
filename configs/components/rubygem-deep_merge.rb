component "rubygem-deep_merge" do |pkg, settings, platform|
  # Projects may define a :rubygem_deep_merge_version setting, or we use 1.0.1 by default:
  version = settings[:rubygem_deep_merge_version] || '1.0.1'
  pkg.version version

  case version
  when "1.0.1"
    pkg.md5sum "6f30bc4727f1833410f6a508304ab3c1"
  when "1.2.1"
    pkg.md5sum "8d8396705375ac646454b1d64ad1239a"
  else
    raise "rubygem-deep_merge version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
