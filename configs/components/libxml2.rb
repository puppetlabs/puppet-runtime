component "libxml2" do |pkg, settings, platform|
  pkg.version '2.12.6'
  pkg.sha256sum '889c593a881a3db5fdd96cc9318c87df34eb648edfc458272ad46fd607353fbb'

  libxml2_version_y = pkg.get_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2')
  pkg.url "https://download.gnome.org/sources/libxml2/#{libxml2_version_y}/libxml2-#{pkg.get_version}.tar.xz"
  pkg.mirror "#{settings[:buildsources_url]}/libxml2-#{pkg.get_version}.tar.xz"

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
  elsif platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:/opt/csw/bin:#{settings[:bindir]}"
    pkg.environment "CFLAGS", "#{settings[:cflags]} -std=c99"
    pkg.environment "LDFLAGS", settings[:ldflags]
  elsif platform.is_macos?
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", settings[:cflags]
    if platform.is_cross_compiled?
      pkg.environment 'CC', 'clang -target arm64-apple-macos11' if platform.name =~ /osx-11/
      pkg.environment 'CC', 'clang -target arm64-apple-macos12' if platform.name =~ /osx-12/
    end
  else
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", settings[:cflags]
  end

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --without-python #{settings[:host]}"]
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
