component "boost" do |pkg, settings, platform|
  # Source-Related Metadata
  pkg.version "1.67.0"
  pkg.md5sum "4850fceb3f2222ee011d4f3ea304d2cb"
  # Apparently boost doesn't use dots to version they use underscores....arg
  pkg.url "http://downloads.sourceforge.net/project/boost/boost/#{pkg.get_version}/boost_#{pkg.get_version.gsub('.','_')}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/boost_#{pkg.get_version.gsub('.','_')}.tar.gz"

  if platform.is_solaris?
    pkg.apply_patch 'resources/patches/boost/0001-fix-build-for-solaris.patch'
  end

  if platform.is_solaris? || platform.is_aix?
    pkg.apply_patch 'resources/patches/boost/solaris-aix-boost-filesystem-unique-path.patch'
  end

  if platform.is_cisco_wrlinux?
    pkg.apply_patch 'resources/patches/boost/no-fionbio.patch'
  end

  if platform.architecture == "aarch64"
    pkg.apply_patch 'resources/patches/boost/boost-aarch64-flags.patch'
  end

  # Package Dependency Metadata

  # Build Requirements
  if platform.is_aix?
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-gcc-5.2.0-1.aix#{platform.os_version}.ppc.rpm"
    pkg.build_requires 'http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/bzip2-1.0.5-3.aix5.3.ppc.rpm'
    pkg.build_requires 'http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/zlib-devel-1.2.3-4.aix5.2.ppc.rpm'
    pkg.build_requires 'http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/zlib-1.2.3-4.aix5.2.ppc.rpm'
  elsif platform.is_cross_compiled_linux?
    pkg.build_requires "pl-binutils-#{platform.architecture}"
    pkg.build_requires "pl-gcc-#{platform.architecture}"
  elsif platform.is_solaris?
    if platform.os_version == "10"
      pkg.build_requires "http://builds.puppetlabs.lan/pl-build-tools/c61ad9a46feb52c8eea3ac477ebe635fd676f80a/artifacts/solaris/10/pl-gcc-6.1.0-7.i386.pkg.gz"
      pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-binutils-2.27-1.#{platform.architecture}.pkg.gz"
    elsif platform.os_version == "11"
      pkg.build_requires "pl-binutils-#{platform.architecture}"
      pkg.build_requires "pl-gcc-#{platform.architecture}"
    end
  elsif platform.is_windows?
    #
  elsif platform.is_macos?
    #
  else
    pkg.build_requires "pl-gcc"
    # Various Linux platforms
    case platform.name
    when /el|fedora/
      pkg.build_requires 'bzip2-devel'
      pkg.build_requires 'zlib-devel'
    when /sles-(11|12)/
      pkg.build_requires 'libbz2-devel'
      pkg.build_requires 'zlib-devel'
    when /debian|ubuntu|Cumulus/i
      pkg.build_requires 'libbz2-dev'
      pkg.build_requires 'zlib1g-dev'
    end
  end

  # Build-time Configuration
  boost_libs = [ 'atomic', 'chrono', 'container', 'date_time', 'exception', 'filesystem', 'graph', 'graph_parallel', 'iostreams', 'locale', 'log', 'math', 'program_options', 'random', 'regex', 'serialization', 'signals', 'system', 'test', 'thread', 'timer', 'wave' ]

  cflags = "-fPIC -std=c99"
  cxxflags = "-std=c++11 -fPIC"

  # These are all places where windows differs from *nix. These are the default *nix settings.
  toolset = 'gcc'
  with_toolset = "--with-toolset=#{toolset}"
  boost_dir = ""
  bootstrap_suffix = ".sh"
  execute = "./"
  addtl_flags = ""
  gpp = "#{settings[:tools_root]}/bin/g++"
  b2flags = ""

  if platform.is_cross_compiled_linux?
    pkg.environment "PATH" => "/opt/pl-build-tools/bin:$$PATH"
    linkflags = "-Wl,-rpath=#{settings[:libdir]}"
    gpp = "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
  elsif platform.is_macos?
    pkg.environment "PATH" => "/opt/pl-build-tools/bin:$$PATH"
    linkflags = ""
    gpp = "clang++"
    toolset = 'gcc'
    with_toolset = "--with-toolset=clang"
  elsif platform.is_solaris?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin'
    linkflags = "-Wl,-rpath=#{settings[:libdir]},-L/opt/pl-build-tools/#{settings[:platform_triple]}/lib,-L/usr/lib"
    b2flags = "define=_XOPEN_SOURCE=600"
    if platform.architecture == "sparc"
      b2flags = "#{b2flags} instruction-set=v9"
    end
    gpp = "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
  elsif platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment "PATH" => "C:/tools/mingw#{arch}/bin:$$PATH"
    pkg.environment "CYGWIN" => "nodosfilewarning"

    # bootstrap.bat does not take the `--with-toolset` flag
    toolset = "gcc"
    with_toolset = ""
    # boost is installed with this extra subdirectory on windows
    boost_dir = "boost-1_67"
    # we do not need to reference the .bat suffix when calling the bootstrap script
    bootstrap_suffix = ""
    # we need to make sure we link against non-cygwin libraries
    execute = "cmd.exe /c "

    gpp = "C:/tools/mingw#{arch}/bin/g++"

    # We don't have iconv available on windows yet
    addtl_flags = "boost.locale.iconv=off"
  else
    pkg.environment "PATH" => "#{settings[:bindir]}:$$PATH"
    linkflags = "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:libdir]}64"

    if platform.is_aix?
      pkg.environment "PATH" => "/opt/freeware/bin:/opt/pl-build-tools/bin:$$PATH"
      linkflags = "-Wl,-rpath=#{settings[:libdir]},-L#{settings[:libdir]},-L/opt/pl-build-tools/lib"
    end
  end

  # Set user-config.jam
  if platform.is_windows?
    userconfigjam = %Q{using gcc : : #{gpp} ;}
  else
    if platform.architecture =~ /arm|s390x/ || platform.is_aix?
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
      "#{execute}bootstrap#{bootstrap_suffix} #{with_toolset}",
      "./b2 install -d+2 \
      --prefix=#{settings[:prefix]} \
      toolset=#{toolset} \
      #{b2flags} \
      --debug-configuration"
    ]
  end

  pkg.install do
    [ "#{settings[:prefix]}/bin/b2 \
    -d+2 \
    toolset=#{toolset} \
    #{b2flags} \
    --debug-configuration \
    --build-dir=. \
    --prefix=#{settings[:prefix]} \
    #{boost_libs.map {|lib| "--with-#{lib}"}.join(" ")} \
    #{addtl_flags} \
    install",
    "chmod 0644 #{settings[:includedir]}/#{boost_dir}/boost/graph/vf2_sub_graph_iso.hpp",
    "chmod 0644 #{settings[:includedir]}/#{boost_dir}/boost/thread/v2/shared_mutex.hpp",
    # Remove the user-config.jam from the build user's home directory:
    "rm -f ~/user-config.jam"
    ]
  end
end
