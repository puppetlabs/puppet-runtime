component "rubygem-fast_gettext" do |pkg, settings, platform|
  version = settings[:rubygem_fast_gettext_version] || '2.3.0'
  pkg.version version

  case version
  when '2.3.0'
    pkg.sha256sum '0253e26423ccab68061c42387827e3b99243a1b15ad614df1c800ba870d64f84'
  when '1.1.2'
    pkg.sha256sum 'e868f02c24af746a137f3aaf898ca3660e6611aa7f1f96ce60e9a425130f2732'
  else
    raise "rubygem-fast_gettext version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
