component "boost" do |pkg, settings, platform|
  # Source-Related Metadata
  pkg.version "1.73.0"
  pkg.md5sum "4036cd27ef7548b8d29c30ea10956196"
  # Apparently boost doesn't use dots to version they use underscores....arg
  pkg.url "http://downloads.sourceforge.net/project/boost/boost/#{pkg.get_version}/boost_#{pkg.get_version.gsub('.','_')}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/boost_#{pkg.get_version.gsub('.','_')}.tar.gz"

  if platform.is_solaris?
    pkg.apply_patch 'resources/patches/boost/0001-fix-build-for-solaris.patch'
    pkg.apply_patch 'resources/patches/boost/force-SONAME-option-for-solaris.patch'
  end

  if platform.name == 'aix-7.1-ppc'
    pkg.apply_patch 'resources/patches/boost/no-O_CLOEXEC-on-aix71.patch'
  end

  if platform.architecture == "aarch64"
    #pkg.apply_patch 'resources/patches/boost/boost-aarch64-flags.patch'
  end

  if platform.is_windows?
    pkg.apply_patch 'resources/patches/boost/windows-thread-declare-do_try_join_until-as-inline.patch'
  end

  # Build-time Configuration

  boost_libs = settings[:boost_libs] || ['atomic', 'chrono', 'container', 'date_time', 'exception', 'filesystem',
                                         'graph', 'graph_parallel', 'iostreams', 'locale', 'log', 'math',
                                         'program_options', 'random', 'regex', 'serialization', 'signals', 'system',
                                         'test', 'thread', 'timer', 'wave']
  cflags = settings[:cflags] + " -fPIC -std=c99"
  cxxflags = settings[:cflags] + " -std=c++11 -fPIC"

  # These are all places where windows differs from *nix. These are the default *nix settings.
  toolset = 'gcc'
  with_toolset = "--with-toolset=#{toolset}"
  boost_dir = ""
  bootstrap_suffix = ".sh"
  bootstrap_flags = settings[:boost_bootstrap_flags] || ""
  execute = "./"
  addtl_flags = ""
  gpp = "#{settings[:tools_root]}/bin/g++"
  b2flags = settings[:boost_b2_flags] || ""
  b2installflags = settings[:boost_b2_install_flags] || ""
  link_option = settings[:boost_link_option]
  b2location = "#{settings[:prefix]}/bin/b2"
  bjamlocation = "#{settings[:prefix]}/bin/bjam"

  if platform.is_cross_compiled_linux?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
    linkflags = "-Wl,-rpath=#{settings[:libdir]}"
    # The boost b2 build requires a c++11 compatible compiler,
    # so we need to install g++ and force the b2 build to use
    # the system g++ for the build of the build tool by using
    # the CXX env var
    #
    # Once the b2 tool has finished building, the actual boost
    # library build will go back to using the cross-compiled
    # g++.
    pkg.environment "CXX", "/usr/bin/g++"
    gpp = "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
  elsif platform.is_macos?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
    linkflags = ""
    gpp = if platform.is_cross_compiled? && platform.name =~ /osx-11/
            "clang++ -target arm64-apple-macos11"
          elsif platform.is_cross_compiled? && platform.name =~ /osx-12/
            "clang++ -target arm64-apple-macos12"
          else
            "clang++"
          end
    toolset = 'gcc'
    with_toolset = "--with-toolset=clang"
  elsif platform.is_solaris?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/ccs/bin:/opt/csw/bin:/usr/sfw/bin'
    linkflags = "-Wl,-rpath=#{settings[:libdir]},-L/opt/pl-build-tools/#{settings[:platform_triple]}/lib,-L/usr/lib"
    b2flags = "define=_XOPEN_SOURCE=600"
    if platform.architecture == "sparc"
      b2flags = "#{b2flags} instruction-set=v9"
    end
    gpp = "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
    with_toolset = toolset
    pkg.environment("LD_LIBRARY_PATH", '/opt/pl-build-tools/lib') if platform.name =~ /solaris-10/
  elsif platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment "PATH", "C:/tools/mingw#{arch}/bin:$(PATH)"
    pkg.environment "CYGWIN", "nodosfilewarning"
    b2location = "#{settings[:prefix]}/bin/b2.exe"
    bjamlocation = "#{settings[:prefix]}/bin/bjam.exe"
    # bootstrap.bat does not take the `--with-toolset` flag
    toolset = "gcc"
    with_toolset = ""
    # we do not need to reference the .bat suffix when calling the bootstrap script
    bootstrap_suffix = ""
    # we need to make sure we link against non-cygwin libraries
    execute = "cmd.exe /c "

    gpp = "C:/tools/mingw#{arch}/bin/g++"

    # Set the address model so we only build one arch
    #
    # By default, boost gets built with WINVER set to the value for Windows XP.
    # We want it to be Vista/Server 2008
    #
    # Set layout to system to avoid nasty version numbers and arches in filenames
    b2flags = "address-model=#{arch} \
               define=WINVER=0x0600 \
               define=_WIN32_WINNT=0x0600 \
               --layout=system"

    # We don't have iconv available on windows yet
    install_only_flags = "boost.locale.iconv=off"
  elsif platform.is_aix?
    pkg.environment "NO_CXX11_CHECK", "1"
    pkg.environment "CXX", "/opt/freeware/bin/g++"
    pkg.environment "CXXFLAGS", "-pthread"
    pkg.environment "PATH", "/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)"
    linkflags = "-Wl,-L#{settings[:libdir]},-L/opt/pl-build-tools/lib"
  elsif platform.name =~ /debian-9|el-[567]|redhatfips-7|sles-(:?11|12)|ubuntu-(:?14.04|16.04|18.04-amd64)/
    pkg.environment "PATH", "/opt/pl-build-tools/bin:#{settings[:bindir]}:$(PATH)"
    linkflags = "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:libdir]}64"
  else
    pkg.environment "PATH", "/opt/pl-build-tools/bin:#{settings[:bindir]}:$(PATH)"
    linkflags = "#{settings[:ldflags]},-rpath=#{settings[:libdir]}64"
    gpp = '/usr/bin/g++'
  end

  # Set user-config.jam
  if platform.is_windows?
    userconfigjam = %Q{using gcc : : #{gpp} ;}
  else
    if platform.architecture =~ /arm/ || platform.is_aix?
      userconfigjam = %Q{using gcc : 5.2.0 : #{gpp} : <linkflags>"#{linkflags}" <cflags>"#{cflags}" <cxxflags>"#{cxxflags}" ;}
    else
      userconfigjam = %Q{using gcc : 4.8.2 : #{gpp} : <linkflags>"#{linkflags}" <cflags>"#{cflags}" <cxxflags>"#{cxxflags}" ;}
    end
  end

  # Build Commands

  # On some platforms, we have multiple means of specifying paths. Sometimes, we need to use either one
  # form or another. `special_prefix` allows us to do this. i.e., on windows, we need to have the
  # windows specific path (C:/), whereas for everything else, we can default to the drive root currently
  # in use (/cygdrive/c). This has to do with how the program is built, where it is expecting to find
  # libraries and binaries, and how it tries to find them.
  pkg.build do
    [
      %Q{echo '#{userconfigjam}' > ~/user-config.jam},
      "cd tools/build",
      "#{execute}bootstrap#{bootstrap_suffix} #{with_toolset} #{bootstrap_flags}",
      "./b2 \
      install \
      variant=release \
      #{link_option} \
      toolset=#{toolset} \
      #{b2flags} \
      -d+2 \
      --prefix=#{settings[:prefix]} \
      --debug-configuration"
    ]
  end

  pkg.install do
    [
      "#{b2location} \
      install \
      variant=release \
      #{link_option} \
      toolset=#{toolset} \
      #{b2flags} \
      #{b2installflags} \
      -d+2 \
      --debug-configuration \
      --prefix=#{settings[:prefix]} \
      --build-dir=. \
      #{boost_libs.map {|lib| "--with-#{lib}"}.join(" ")} \
      #{install_only_flags}",
      "chmod 0644 #{settings[:includedir]}/boost/graph/vf2_sub_graph_iso.hpp",
      "chmod 0644 #{settings[:includedir]}/boost/thread/v2/shared_mutex.hpp",
      # Remove extraneous Boost.Build stuff:
      "rm -f ~/user-config.jam",
      "rm -rf #{settings[:prefix]}/share/boost-build",
      "rm -f #{b2location}",
      "rm -f #{bjamlocation}",
    ]
  end

  # Boost.Build's behavior around setting the install_name for dylibs on macOS
  # is not easily configurable. By default, it will hard-code the relative build
  # directory there, making the libraries unusable once they're moved to the
  # puppet libdir. Instead of dealing with this in a jamfile somewhere, we'll
  # use a script to manually rewrite the finshed dylibs' install_names to use
  # @rpath instead of the build directory.
  if platform.is_macos?
    pkg.add_source("file://resources/files/boost/macos_rpath_install_names.sh")
    pkg.configure do
      [
        "cp ../macos_rpath_install_names.sh macos_rpath_install_names.sh",
        "chmod +x macos_rpath_install_names.sh",
      ]
    end
    pkg.install do
      [
        "LIBDIR=#{settings[:libdir]} ./macos_rpath_install_names.sh",
      ]
    end
  end
end
