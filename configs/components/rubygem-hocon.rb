component "rubygem-hocon" do |pkg, settings, platform|
  version = settings[:rubygem_hocon_version] || '1.3.1'
  pkg.version version

  case version
  when '1.3.1'
    pkg.md5sum "9182e012c0d48d0512a1b49179616709"
  when '1.4.0'
    pkg.sha256sum "e71023ed7c56ae780ec34c0ce7789a233bcead08c045d50bc7b3af40f5afcd80"
  else
    raise "rubygem-hocon version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
