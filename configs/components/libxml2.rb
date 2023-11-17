component "libxml2" do |pkg, settings, platform|
  pkg.version '2.10.3'
  pkg.sha256sum '497f12e34790d407ec9e2a190d576c0881a1cd78ff3c8991d1f9e40281a5ff57'
  pkg.url "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v#{pkg.get_version}/libxml2-v#{pkg.get_version}.tar.gz"

  if platform.is_aix?
    if platform.name == 'aix-7.1-ppc'
      pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
    else
      pkg.environment "PATH", "/opt/freeware/bin:$(PATH)"
    end
  elsif platform.is_cross_compiled_linux?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment "LDFLAGS", settings[:ldflags]
  elsif platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:#{settings[:bindir]}"
    pkg.environment "CFLAGS", "#{settings[:cflags]} -std=c99"
    pkg.environment "LDFLAGS", settings[:ldflags]
  elsif platform.is_macos?
    pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin:/usr/local/bin'
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

  build_deps = [ "runtime-#{settings[:runtime_project]}" ]

  if platform.is_sles?
    build_deps << "autoconf"
  elsif platform.is_deb? || platform.is_rpm?
    build_deps << "dh-autoreconf"
  end

  if platform.name == 'el-8-x86_64' || platform.name == 'el-9-x86_64'
    build_deps.reject! { |r| r == 'dh-autoreconf' }
  end

  build_deps.each do |dep|
    pkg.build_requires dep
  end

  # Newer versions of libxml2 either ship as tar.xz or do not ship with a configure file
  # and require a newer version of GNU Autotools to generate. This causes problems with
  # the older and esoteric (AIX, Solaris) platforms that we support.
  # So we generate a configure file manually, compress as tar.gz, and host internally.
  if (platform.is_aix? && platform.name == 'aix-7.1-ppc') || platform.is_solaris?
    pkg.url "#{settings[:buildsources_url]}/libxml2-#{pkg.get_version}-puppet.tar.gz"
    pkg.sha256sum '26d2415e1c23e0aad8ca52358523fc9116a2eb6e4d4ef47577b1635c7cee3d5f'
  else
    pkg.mirror "#{settings[:buildsources_url]}/libxml2-#{pkg.get_version}.tar.gz"
    # Patch downgrades autotools requirement from 1.16.3 to 1.15
    # EL8 era distros and older do not support 1.16.3.
    # Vendor only required it to fix a python 3.10 detection bug,
    # 1.15 works just fine for our build.
    pkg.apply_patch 'resources/patches/libxml2/configure.ac.patch'
    pkg.configure { ["autoreconf --force --install"] }
  end

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
