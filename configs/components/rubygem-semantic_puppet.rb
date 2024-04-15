component "rubygem-semantic_puppet" do |pkg, settings, platform|
  # Projects may define a :rubygem_semantic_puppet_version setting, or we use 1.0.4 by default
  version = settings[:rubygem_semantic_puppet_version] || '1.1.0'
  pkg.version version

  case version
  when '0.1.2'
    pkg.md5sum '192ae7729997cb5d5364f64b99b13121'
  when '1.1.0'
    pkg.sha256sum "52d108d08e1a5d95c00343cb3a4936fb1deecff2be612ec39c9cb66be5a8b859"
  else
    raise "rubygem-semantic_puppet version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
