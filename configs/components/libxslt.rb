component "libxslt" do |pkg, settings, platform|
  pkg.version "1.1.33"
  pkg.md5sum "b3bd254a03e46d58f8ad1e4559cd2c2f"
  pkg.url "http://xmlsoft.org/sources/#{pkg.get_name}-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/libxslt-#{pkg.get_version}.tar.gz"

  pkg.build_requires "libxml2"

  pkg.apply_patch 'resources/patches/libxslt/CVE-2019-11068.patch'

  if platform.is_aix?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
  elsif platform.is_cross_compiled_linux?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment "LDFLAGS", settings[:ldflags]

    # libxslt is picky about manually specifying the build host
    build = "--build x86_64-linux-gnu"
    # don't depend on libgcrypto
    disable_crypto = "--without-crypto"
  elsif platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:#{settings[:bindir]}"
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment "LDFLAGS", settings[:ldflags]
    # Configure on Solaris incorrectly passes flags to ld
    pkg.apply_patch 'resources/patches/libxslt/disable-version-script.patch'
    pkg.apply_patch 'resources/patches/libxslt/Update-missing-script-to-return-0.patch'
  elsif platform.is_macos?
    pkg.environment "CC" => "clang -target arm64-apple-macos11" if platform.is_cross_compiled?
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", settings[:cflags]
  else
    pkg.environment "LDFLAGS" => settings[:ldflags]
    pkg.environment "CFLAGS" => settings[:cflags]
  end

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --docdir=/tmp --with-libxml-prefix=#{settings[:prefix]} #{settings[:host]} #{disable_crypto} #{build}"]
  end

  pkg.build do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:datadir]}/gtk-doc",
      "rm -rf #{settings[:datadir]}/doc/#{pkg.get_name}*"
    ]
  end

end
