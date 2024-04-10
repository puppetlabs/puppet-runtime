component "rubygem-gettext" do |pkg, settings, platform|
  version = settings[:rubygem_gettext_version] || '3.4.3'
  pkg.version version

  case version
  when '3.4.3'
    pkg.sha256sum '1b98e1272d0f55a56f519ee86d24e0fcd114b94c9d10b26e72512d65f9174251'
  when '3.2.2'
    pkg.sha256sum '9d250bb79273efb4a268977f219d2daca05cdc7473eff40288b8ab8ddd0f51b4'
  else
    raise "rubygem-gettext version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  gem_home = settings[:puppet_gem_vendor_dir] || settings[:gem_home]
  pkg.environment "GEM_HOME", gem_home

  case version
  when '3.4.3'
    install do
      "rm -f #{gem_home}/gems/gettext-3.4.3/test/fixtures/gtk_builder_ui_definitions.ui~"
    end
  end
end
