component "yaml-cpp" do |pkg, settings, platform|
  pkg.url "git://github.com/jbeder/yaml-cpp.git"
  pkg.ref "refs/tags/yaml-cpp-0.6.2"

  # Build-time Configuration
  cmake_toolchain_file = ''
  cmake = '/usr/bin/cmake'
  make = 'make'
  mkdir = 'mkdir'

  if platform.is_cross_compiled_linux?
    # We're using the x86_64 version of cmake
    cmake = "/opt/pl-build-tools/bin/cmake"
    cmake_toolchain_file = "-DPL_TOOLS_ROOT=/opt/freeware -DCMAKE_TOOLCHAIN_FILE=#{settings[:tools_root]}/#{settings[:platform_triple]}/pl-build-toolchain.cmake"
  elsif platform.is_solaris?
    if platform.os_version == "11"
      make = '/usr/bin/gmake'
    end
    # We always use the i386 build of cmake, even on sparc
    cmake = "/opt/pl-build-tools/i386-pc-solaris2.#{platform.os_version}/bin/cmake"
    cmake_toolchain_file = "-DCMAKE_TOOLCHAIN_FILE=#{settings[:tools_root]}/#{settings[:platform_triple]}/pl-build-toolchain.cmake"
    pkg.environment "PATH" => "$$PATH:/opt/csw/bin"
  elsif platform.is_macos?
    cmake_toolchain_file = ""
    cmake = "/usr/local/bin/cmake"
    pkg.environment "CXX" => "clang++ -target arm64-apple-macos11" if platform.is_cross_compiled?
  elsif platform.is_windows?
    make = "#{settings[:gcc_bindir]}/mingw32-make"
    mkdir = '/usr/bin/mkdir'
    pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:ruby_bindir]}):/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0"
    pkg.environment "CYGWIN", settings[:cygwin]
    cmake = "C:/ProgramData/chocolatey/bin/cmake.exe -G \"MinGW Makefiles\""
    cmake_toolchain_file = "-DCMAKE_TOOLCHAIN_FILE=#{settings[:tools_root]}/pl-build-toolchain.cmake"
  elsif platform.is_aix? || platform.name =~ /cisco-wrlinux-[57]|debian-9|el-[567]|eos-4|redhatfips-7|sles-(:?11|12)|ubuntu-(:?14.04|16.04|18.04)/
    cmake = "#{settings[:tools_root]}/bin/cmake"
    cmake_toolchain_file = "-DCMAKE_TOOLCHAIN_FILE=#{settings[:tools_root]}/pl-build-toolchain.cmake"
  else
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
  end

  # Build Commands
  pkg.build do
    [ "#{mkdir} build",
      "cd build",
      "#{cmake} \
      #{cmake_toolchain_file} \
      -DCMAKE_INSTALL_PREFIX=#{settings[:prefix]} \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DYAML_CPP_BUILD_TOOLS=0 \
      -DYAML_CPP_BUILD_TESTS=0 \
      -DBUILD_SHARED_LIBS=ON \
      .. ",
      "#{make} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
    ]
  end

  pkg.install do
    [ "cd build",
      "#{make} install",
    ]
  end
end
