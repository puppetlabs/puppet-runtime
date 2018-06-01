component "rubygem-semantic_puppet" do |pkg, settings, platform|
  # Projects may define a :rubygem_semantic_puppet_version setting, or we use 1.0.2 by default
  version = settings[:rubygem_semantic_puppet_version] || '1.0.2'
  pkg.version version

  case version
  when '0.1.2'
    pkg.md5sum '192ae7729997cb5d5364f64b99b13121'
  when '1.0.2'
    pkg.md5sum "48f4a060e6004604e2f46716bfeabcdc"
  else
    raise "rubygem-semantic_puppet version #{version} has not been configured; Cannot continue."
  end
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.url "https://rubygems.org/downloads/semantic_puppet-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/semantic_puppet-#{pkg.get_version}.gem"
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])

  pkg.install do
    ["#{settings[:gem_install]} semantic_puppet-#{pkg.get_version}.gem"]
  end
end
