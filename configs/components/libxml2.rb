component "libxml2" do |pkg, settings, platform|
  pkg.version "2.9.8"
  pkg.md5sum "b786e353e2aa1b872d70d5d1ca0c740d"
  pkg.url "http://xmlsoft.org/sources/#{pkg.get_name}-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/libxml2-#{pkg.get_version}.tar.gz"
  # CVE-related patches needed until libxml 2.9.9 is released:
  pkg.apply_patch 'resources/patches/libxml2/fix_nullptr_deref_with_XPath_logic_ops.patch'
  pkg.apply_patch 'resources/patches/libxml2/fix_infinite_loop_in_LZMA_decompression.patch'

  # We need to use the -std=c99 flag on some platforms because libxml 2.9.8
  # relies on the C99 macros NAN, INFINITY, isnan, isinf. See https://github.com/GNOME/libxml2/commit/8813f397f8925f85ffbe9e9fb62bfaa3c1accf11
  # for more details.
  #
  # NOTE: Although 8813f's message indicates that the -std=c99 flag is _not_
  # strictly necessary (since libxml2 will define the C99 macros if they're not
  # available), we choose to use it here as otherwise, libxml2 fails to compile
  # on AIX and Solaris. Better to use the flag than try to patch it ourselves.
  if platform.is_aix?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
    pkg.environment "CFLAGS", "-std=c99"
  elsif platform.is_cross_compiled_linux?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment "LDFLAGS", settings[:ldflags]
  elsif platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:#{settings[:bindir]}"
    pkg.environment "CFLAGS", "#{settings[:cflags]} -std=c99"
    pkg.environment "LDFLAGS", settings[:ldflags]
  elsif platform.is_macos?
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", settings[:cflags]
  else
    if platform.is_el? && platform.name =~ /-5/
      # RHEL 5 uses GCC 4.1.2, which does not support the -Wno-array-bounds option required
      # by libxml2. This option was introduced in GCC 4.6. Thus for RHEL 5, we use pl-gcc
      # instead.
      pkg.environment "CC" => "/opt/pl-build-tools/bin/gcc"
    end

    pkg.environment "LDFLAGS" => settings[:ldflags]
    pkg.environment "CFLAGS" => settings[:cflags]
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
