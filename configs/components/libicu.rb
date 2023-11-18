component 'libicu' do |pkg, settings, platform|
  ## SOURCE METADATA
  pkg.version '62.1'
  underscore_version = pkg.get_version.gsub('.', '_')
  dash_version = pkg.get_version.gsub('.', '-')
  pkg.md5sum '490ad9d920158e0314e10ba74ae9a150'
  pkg.url "https://github.com/unicode-org/icu/releases/download/release-#{dash_version}/icu4c-#{underscore_version}-src.tgz"
  pkg.mirror "#{settings[:buildsources_url]}/icu4c-#{underscore_version}-src.tgz"
  pkg.dirname "icu/source"

  # Instead of using the pre-built data library included in the icu source, we
  # build our own custom library with certain unnecessary bits of data removed
  # to reduce filesize.
  pkg.add_source("#{settings[:buildsources_url]}/icu4c-#{underscore_version}-data.zip", sum: "07e03444244883ef9789a56fc25010c0")

  # These rules restrict the set of locales we build, which significantly
  # reduces the size of the resulting package.
  %w[curr lang locales region unit zone].each do |dir|
    pkg.add_source("file://resources/files/libicu/#{dir}_reslocal.mk")
  end

  if platform.is_linux?
    if platform.name =~ /el-[67]|redhatfips-7|sles-12|ubuntu-18.04-amd64/
      pkg.build_requires 'pl-gcc'
    else
      pkg.build_requires 'gcc'
    end
    pkg.build_requires 'unzip'
  elsif platform.is_windows?
    pkg.build_requires '7zip.commandline'
  end

  ## BUILD CONFIGURATION
  if platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:chocolatey_bin]}):$(PATH)"
    pkg.environment 'CYGWIN', settings[:cygwin]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CXX', settings[:cxx]
    pkg.environment 'MAKE', platform[:make]
  elsif platform.is_macos?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'
  else
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'
  end

  ## BUILD COMMANDS
  pkg.configure do
    if platform.is_windows?
      icu_platform = 'MinGW'
      icu_flags = "--host #{platform.platform_triple}"
      # Workaround for http://bugs.icu-project.org/trac/ticket/12896
      cxx_flags = '-DU_USE_STRTOD_L=0'
    elsif platform.is_macos?
      icu_platform = 'MacOSX'
      icu_flags = '--enable-rpath'
    else
      icu_platform = 'Linux/gcc'
    end

    [# Remove the pre-built data library from the source tarball and copy in
     # the data sources
     "rm -rf data && mv ../../icu4c-#{underscore_version}-data/data data",
     # Removing these makefiles prevents building conversion tables for
     # encodings we don't need, reducing the resulting filesize
     "rm data/mappings/ucmfiles.mk data/mappings/ucmebcdic.mk",
     "for file in ../../*_reslocal.mk; do mv $$file data/$$(basename $$file _reslocal.mk)/reslocal.mk; done",
     "LDFLAGS='#{settings[:ldflags]}' CXXFLAGS='#{cxx_flags}' ./runConfigureICU #{icu_platform} #{icu_flags} --prefix=#{settings[:prefix]}"]
  end

  pkg.build do
    if platform.is_macos? && platform.is_cross_compiled?
      # In order to cross compile icu on macOS, we have to build twice. Once for
      # the current build platform, then again for the intended host platform in
      # a different directory, while passing the first directory as the
      # `with-cross-build` option.
      #
      # The `runConfigureICU` script doesn't support cross-compiling, so copy
      # the icu_flags from above and call `./configure` directly with the
      # options needed to cross compile.
      icu_flags = '--enable-rpath'
      [
        "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) VERBOSE=1",
        "mkdir build.arm64",
        "cd build.arm64",
        "CXX='clang++ -target arm64-apple-macos12' CC='clang -target arm64-apple-macos12' ../configure #{icu_flags} --prefix=#{settings[:prefix]} --host=arm-apple-darwin --build=x86_64-apple-darwin --with-cross-build=$$PWD/..",
        "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) VERBOSE=1"
      ]
    else
      ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
    end
  end

  pkg.install do
    if platform.is_macos? && platform.is_cross_compiled?
      install_cmds = ["cd build.arm64 && #{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
    else
      install_cmds = ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
    end

    # ICU incorrectly installs its .dlls to lib instead of bin on windows, so
    # we have to move them...
    if platform.is_windows?
      install_cmds << "mv #{settings[:libdir]}/icu*.dll #{settings[:bindir]}"
    end
    install_cmds
  end
end

