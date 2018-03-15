component "ruby-2.1.9" do |pkg, settings, platform|
  pkg.version "2.1.9"
  pkg.md5sum "d9d2109d3827789344cc3aceb8e1d697"

  # Most ruby configuration happens in the base ruby config:
  instance_eval File.read('configs/components/base-ruby.rb')
  # Configuration below should only be applicable to ruby 2.1.9

  ###########
  # RBCONFIGS
  ###########

  # These are a pretty smelly hack, and they run the risk of letting tests
  # based on the generated data (that should otherwise fail) pass
  # erroneously. We should probably fix the "not shipping our compiler"
  # problem that led us to do this sooner rather than later.
  #   Ryan McKern, 26/09/2015
  #   Reference notes:
  #   - 6b089ed2: Provide a sane rbconfig for AIX
  #   - 8e88a51a: (RE-5401) Add rbconfig for solaris 11 sparc
  #   - 8f10f5f8: (RE-5400) Roll rbconfig for solaris 11 back to 2.1.6
  #   - 741d18b1: (RE-5400) Update ruby for solaris 11 i386
  #   - d09ed06f: (RE-5290) Update ruby to replace rbconfig for all solaris
  #   - bba35c1e: (RE-5290) Update ruby for a cross-compile on solaris 10
  rbconfig_info = {
    'powerpc-ibm-aix6.1.0.0' => {
      :sum => "82ee3719187cba9bbf6f4b7088b52305",
      :target_double => "powerpc-aix6.1.0.0",
    },
    'powerpc-ibm-aix7.1.0.0' => {
      :sum => "960fb03d7818fec612f3be598c6964d2",
      :target_double => "powerpc-aix7.1.0.0",
     },
    'aarch64-redhat-linux' => {
      :sum => "d7d0b046cdd1766e989da542e3fd3043",
      :target_double => "aarch64-linux",
    },
    'ppc64le-redhat-linux' => {
      :sum => "97f599edab5dec39b3231fc67b7208b5",
      :target_double => "powerpc64le-linux",
    },
    'powerpc64le-suse-linux' => {
      :sum => "ce3b130c6c5eb7ff4e8af5ad2191d1ba",
      :target_double => "powerpc64le-linux",
    },
    'powerpc64le-linux-gnu' => {
      :sum => "bde91496039b1b621becded574a4c5ab",
      :target_double => "powerpc64le-linux",
    },
    's390x-linux-gnu' => {
      :sum => "dc6341fff1d00b3ba22dc1b9e6d5532f",
      :target_double => "s390x-linux",
    },
    'i386-pc-solaris2.10' => {
      :sum => "9078034711ef1b047dcb7416134c55ae",
      :target_double => 'i386-solaris2.10',
    },
    'sparc-sun-solaris2.10' => {
      :sum => "3fbceb4f70e086a6df52c206ca17211b",
      :target_double => 'sparc-solaris2.10',
    },
    'i386-pc-solaris2.11' => {
      :sum => "224822682a570aceec965c75ca00d882",
      :target_double => 'i386-solaris2.11',
    },
    'sparc-sun-solaris2.11' => {
      :sum => "f2a40c4bff028dffc880a40b2806a361",
      :target_double => 'sparc-solaris2.11',
    },
    'arm-linux-gnueabihf' => {
      :target_double => 'arm-linux-eabihf'
    },
    'x86_64-w64-mingw32' => {
      :sum => "fe5656cd5fcba0a63b18857275e03808",
      :target_double => 'x64-mingw32',
    },
    'i686-w64-mingw32' => {
      :sum => "795fd622cca6459146cfb226c74ba058",
      :target_double => 'i386-mingw32',
    },
  }

  #########
  # PATCHES
  #########

  base = 'resources/patches/ruby_219'
  pkg.apply_patch "#{base}/libyaml_cve-2014-9130.patch"

  # Patches from Ruby 2.4 security fixes. See the description and
  # comments of RE-9323 for more details.
  pkg.apply_patch "#{base}/cve-2017-0898.patch"
  pkg.apply_patch "#{base}/cve-2017-10784.patch"
  pkg.apply_patch "#{base}/cve-2017-14033.patch"
  pkg.apply_patch "#{base}/cve-2017-14064.patch"
  pkg.apply_patch "#{base}/cve-2017-17405.patch"

  if platform.is_aix?
    pkg.apply_patch "#{base}/aix_ruby_2.1_libpath_with_opt_dir.patch"
    pkg.apply_patch "#{base}/aix_ruby_2.1_fix_proctitle.patch"
    pkg.apply_patch "#{base}/aix_ruby_2.1_fix_make_test_failure.patch"
    pkg.apply_patch "#{base}/Remove-O_CLOEXEC-check-for-AIX-builds.patch"
  end

  if platform.is_windows?
    pkg.apply_patch "#{base}/windows_ruby_2.1_update_to_rubygems_2.4.5.patch"
    pkg.apply_patch "#{base}/windows_fixup_generated_batch_files.patch"
    pkg.apply_patch "#{base}/windows_remove_DL_deprecated_warning.patch"
    pkg.apply_patch "#{base}/windows_ruby_2.1_update_to_rubygems_2.4.5.1.patch"
    pkg.apply_patch "#{base}/update_rbinstall_for_windows.patch"
    pkg.apply_patch "#{base}/windows_rubygems_cve_2017_0902_0899_0900_0901.patch"
  else
    pkg.apply_patch "#{base}/rubygems_cve_2017_0902_0899_0900_0901.patch"
  end

  ####################
  # ENVIRONMENT, FLAGS
  ####################

  special_flags = " --prefix=#{settings[:ruby_dir]} --with-opt-dir=#{settings[:prefix]} "

  if platform.is_aix?
    # This normalizes the build string to something like AIX 7.1.0.0 rather
    # than AIX 7.1.0.2 or something
    special_flags += " --build=#{settings[:platform_triple]} "
  elsif platform.is_solaris? && platform.architecture == "sparc"
    special_flags += " --with-baseruby=#{settings[:host_ruby]} "
  elsif platform.is_cross_compiled_linux?
    special_flags += " --with-baseruby=#{settings[:host_ruby]} "
  elsif platform.is_windows?
    special_flags = " CPPFLAGS='-DFD_SETSIZE=2048' debugflags=-g --prefix=#{settings[:ruby_dir]} --with-opt-dir=#{settings[:prefix]} "
  end

  ###########
  # CONFIGURE
  ###########

  # Here we set --enable-bundled-libyaml to ensure that the libyaml included in
  # ruby is used, even if the build system has a copy of libyaml available
  pkg.configure do
    [
      "bash configure \
        --enable-shared \
        --enable-bundled-libyaml \
        --disable-install-doc \
        --disable-install-rdoc \
        #{settings[:host]} \
        #{special_flags}"
     ]
  end

  #########
  # INSTALL
  #########

  if platform.is_cross_compiled_linux? || platform.is_solaris? || platform.is_aix?
    # Here we replace the rbconfig from our ruby compiled with our toolchain
    # with an rbconfig from a ruby of the same version compiled with the system
    # gcc. Without this, the rbconfig will be looking for a gcc that won't
    # exist on a user system and will also pass flags which may not work on
    # that system.
    # We also disable a safety check in the rbconfig to prevent it from being
    # loaded from a different ruby, because we're going to do that later to
    # install compiled gems.
    #
    # On AIX we build everything using our own GCC. This means that gem
    # installing a compiled gem would not work without us shipping that gcc.
    # This tells the ruby setup that it can use the default system gcc rather
    # than our own.
    target_dir = File.join(settings[:ruby_dir], 'lib', 'ruby', '2.1.0', rbconfig_info[settings[:platform_triple]][:target_double])
    sed = "sed"
    sed = "gsed" if platform.is_solaris?
    sed = "/opt/freeware/bin/sed" if platform.is_aix?

    pkg.install do
      [
        "#{sed} -i 's|raise|warn|g' #{target_dir}/rbconfig.rb",
        "mkdir -p #{settings[:datadir]}/doc",
        "cp #{target_dir}/rbconfig.rb #{settings[:datadir]}/doc",
        "cp ../rbconfig-#{settings[:platform_triple]}.rb #{target_dir}/rbconfig.rb",
      ]
    end
  end
end
