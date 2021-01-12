component "rubygem-semantic_puppet" do |pkg, settings, platform|
  # Projects may define a :rubygem_semantic_puppet_version setting, or we use 1.0.3 by default
  version = settings[:rubygem_semantic_puppet_version] || '1.0.3'
  pkg.version version

  case version
  when '0.1.2'
    pkg.md5sum '192ae7729997cb5d5364f64b99b13121'
  when '1.0.3'
    pkg.sha256sum "3b83bff3bed1188d603947184c0e3ee4443543e3e832edccc7127b6209bb292b"
  else
    raise "rubygem-semantic_puppet version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
