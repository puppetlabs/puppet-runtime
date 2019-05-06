component "rubygem-fast_gettext" do |pkg, settings, platform|
  version = settings[:rubygem_fast_gettext_version] || '1.1.2'
  pkg.version version

  case version
    when '1.1.0'
      pkg.md5sum "fc0597bd4d84b749c579cc39c7ceda0f"
    when '1.1.2'
      pkg.md5sum "df5a2462d0e1d2e5d49bb233b841f4d6"
    else
      raise "rubygem-fast_gettext version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
