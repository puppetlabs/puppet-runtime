component "libxslt" do |pkg, settings, platform|
  pkg.version '1.1.37'
  pkg.sha256sum '3a4b27dc8027ccd6146725950336f1ec520928f320f144eb5fa7990ae6123ab4'

  libxslt_version_y = pkg.get_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2')
  pkg.url "https://download.gnome.org/sources/libxslt/#{libxslt_version_y}/libxslt-#{pkg.get_version}.tar.xz"
  pkg.mirror "#{settings[:buildsources_url]}/libxslt-#{pkg.get_version}.tar.xz"

  pkg.build_requires "libxml2"

  if platform.is_aix?
    if platform.name == 'aix-7.1-ppc'
      pkg.environment "PATH", "/opt/pl-build-tools/bin:/opt/freeware/bin:$(PATH)"
    else
      pkg.environment "PATH", "/opt/freeware/bin:$(PATH)"
    end
  elsif platform.is_cross_compiled_linux?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment "LDFLAGS", settings[:ldflags]

    # libxslt is picky about manually specifying the build host
    build = "--build x86_64-linux-gnu"
    # don't depend on libgcrypto
    disable_crypto = "--without-crypto"
  elsif platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:/opt/csw/bin:#{settings[:bindir]}"
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment "LDFLAGS", settings[:ldflags]
  elsif platform.is_macos?
    if platform.is_cross_compiled?
      pkg.environment 'CC', 'clang -target arm64-apple-macos11' if platform.name =~ /osx-11/
      pkg.environment 'CC', 'clang -target arm64-apple-macos12' if platform.name =~ /osx-12/
    end
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", settings[:cflags]
  else
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", settings[:cflags]
  end

  pkg.configure do
    ["./configure --without-python --prefix=#{settings[:prefix]} --docdir=/tmp --with-libxml-prefix=#{settings[:prefix]} #{settings[:host]} #{disable_crypto} #{build}"]
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
