component 'dmidecode' do |pkg, settings, platform|
  pkg.version '3.3'
  pkg.md5sum 'afca949fd71a23dd39c4a3c9cd946dc0'

  pkg.apply_patch 'resources/patches/dmidecode/1117390c.patch'
  pkg.apply_patch 'resources/patches/dmidecode/11e134e5.patch'

  pkg.apply_patch 'resources/patches/dmidecode/dmidecode-install-to-bin.patch'
  pkg.url "http://download.savannah.gnu.org/releases/dmidecode/dmidecode-#{pkg.get_version}.tar.xz"
  pkg.mirror "#{settings[:buildsources_url]}/dmidecode-#{pkg.get_version}.tar.xz"

  pkg.environment "LDFLAGS", settings[:ldflags]
  pkg.environment "CFLAGS", settings[:cflags]

  if platform.is_cross_compiled?
    # The Makefile doesn't honor environment overrides, so we need to
    # edit it directly for cross-compiling
    pkg.configure do
      ["sed -i \"s|gcc|/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc|g\" Makefile"]
    end
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} prefix=#{settings[:prefix]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -f #{settings[:bindir]}/vpddecode #{settings[:bindir]}/biosdecode #{settings[:bindir]}/ownership",
      "rm -f #{settings[:mandir]}/man8/ownership.8 #{settings[:mandir]}/man8/biosdecode.8 #{settings[:mandir]}/man8/vpddecode.8"
    ]
  end
end
