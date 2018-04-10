component 'ruby-2.4.4' do |pkg, settings, platform|
  pkg.version '2.4.4'
  pkg.md5sum "d50e00ccc1c9cf450f837b92d3ed3e88"

  # Most ruby configuration happens in the base ruby config:
  instance_eval File.read('configs/components/_base-ruby.rb')
  # Configuration below should only be applicable to ruby 2.4.4

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
      sum: 'dd3232f385602b45bdbf5e60128d8a19',
      target_double: 'powerpc-aix6.1.0.0',
    },
    'powerpc-ibm-aix7.1.0.0' => {
      sum: '5ba750ff904c51104d9eb33716370b84',
      target_double: 'powerpc-aix7.1.0.0',
     },
    'aarch64-redhat-linux' => {
      sum: '30b729a8397b0ce82a1d45cd00e4bd86',
      target_double: 'aarch64-linux',
    },
    'ppc64le-redhat-linux' => {
      sum: '75f856df15c48c50514c803947f60bf9',
      target_double: 'powerpc64le-linux',
    },
    'powerpc64le-suse-linux' => {
      sum: '00247ac1d0a9e59b1fcfb72025e7d628',
      target_double: 'powerpc64le-linux',
    },
    'powerpc64le-linux-gnu' => {
      sum: '55e9426a06726f2baa82cc561f073fbf',
      target_double: 'powerpc64le-linux',
    },
    's390x-linux-gnu' => {
      sum: 'cbcf3d927bf69b15deb7a7555efdc04e',
      target_double: 's390x-linux',
    },
    'i386-pc-solaris2.10' => {
      sum: 'a3c043187b645c315aff56dadf996570',
      target_double: 'i386-solaris2.10',
    },
    'sparc-sun-solaris2.10' => {
      sum: '72b7fdb633be6d3a6f611bc57ad8bc82',
      target_double: 'sparc-solaris2.10',
    },
    'i386-pc-solaris2.11' => {
      sum: '7adedea72967ffae053ac8930f153e64',
      target_double: 'i386-solaris2.11',
    },
    'sparc-sun-solaris2.11' => {
      sum: '89956d3af3481972c20f250b56e527e7',
      target_double: 'sparc-solaris2.11',
    },
    'arm-linux-gnueabihf' => {
      target_double: 'arm-linux-eabihf'
    },
    'arm-linux-gnueabi' => {
      target_double: 'arm-linux-eabi'
    },
    'x86_64-w64-mingw32' => {
      sum: 'a93cbbeebb5f30ddf3e40de653f42ac9',
      target_double: 'x64-mingw32',
    },
    'i686-w64-mingw32' => {
      sum: '07d789921e433dd7afdeb46a5d22d1f5',
      target_double: 'i386-mingw32',
    },
  }

  ####################
  # BUILD REQUIREMENTS
  ####################

  if platform.is_aix?
    pkg.build_requires 'http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/zlib-1.2.3-4.aix5.2.ppc.rpm'

    # TODO: Remove this once PA-1607 is resolved.
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/aix/5.3/ppc/pl-autoconf-2.69-1.aix5.3.ppc.rpm'
  end

  #########
  # PATCHES
  #########

  base = 'resources/patches/ruby_244'
  pkg.apply_patch "#{base}/ostruct_remove_safe_nav_operator.patch"
  # This patch creates our server/client shared Gem path, used for all gems
  # that are dependencies of the shared Ruby code.
  pkg.apply_patch "#{base}/rubygems_add_puppet_vendor_dir.patch"

  if platform.is_cross_compiled?
    pkg.apply_patch "#{base}/uri_generic_remove_safe_nav_operator.patch"
  end

  if platform.is_aix?
    # TODO: Remove this patch once PA-1607 is resolved.
    pkg.apply_patch "#{base}/aix_revert_configure_in_changes.patch"

    pkg.apply_patch "#{base}/aix_ruby_libpath_with_opt_dir.patch"
    pkg.apply_patch "#{base}/aix_use_pl_build_tools_autoconf.patch"
    pkg.apply_patch "#{base}/aix_ruby_2.1_fix_make_test_failure.patch"
    pkg.apply_patch "#{base}/Remove-O_CLOEXEC-check-for-AIX-builds.patch"
  end

  if platform.is_windows?
    pkg.apply_patch "#{base}/windows_fixup_generated_batch_files.patch"
    pkg.apply_patch "#{base}/update_rbinstall_for_windows.patch"
    pkg.apply_patch "#{base}/PA-1124_add_nano_server_com_support-8feb9779182bd4285f3881029fe850dac188c1ac.patch"
    pkg.apply_patch "#{base}/windows_socket_compat_error.patch"
  end

  ####################
  # ENVIRONMENT, FLAGS
  ####################

  if platform.is_macos?
    pkg.environment 'optflags', settings[:cflags]
  elsif platform.is_windows?
    pkg.environment 'optflags', settings[:cflags] + ' -O3'
  else
    pkg.environment 'optflags', '-O2'
  end

  special_flags = " --prefix=#{settings[:ruby_dir]} --with-opt-dir=#{settings[:prefix]} "

  if platform.is_aix?
    # This normalizes the build string to something like AIX 7.1.0.0 rather
    # than AIX 7.1.0.2 or something
    special_flags += " --build=#{settings[:platform_triple]} "
  elsif platform.is_cross_compiled_linux?
    special_flags += " --with-baseruby=#{settings[:host_ruby]} "
  elsif platform.is_solaris? && platform.architecture == "sparc"
    special_flags += " --with-baseruby=#{settings[:host_ruby]} --enable-close-fds-by-recvmsg-with-peek "
  elsif platform.is_windows?
    special_flags = " CPPFLAGS='-DFD_SETSIZE=2048' debugflags=-g --prefix=#{settings[:ruby_dir]} --with-opt-dir=#{settings[:prefix]} "
  end

  ###########
  # CONFIGURE
  ###########

  # TODO: Remove this once PA-1607 is resolved.
  pkg.configure { ["/opt/pl-build-tools/bin/autoconf"] } if platform.is_aix?

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

  if platform.is_cross_compiled_linux? || platform.is_solaris? || platform.is_aix? || platform.is_windows?
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
    target_dir = File.join(settings[:ruby_dir], 'lib', 'ruby', '2.4.0', rbconfig_info[settings[:platform_triple]][:target_double])
    sed = "sed"
    sed = "gsed" if platform.is_solaris?
    sed = "/opt/freeware/bin/sed" if platform.is_aix?
    pkg.install do
      [
        "#{sed} -i 's|raise|warn|g' #{target_dir}/rbconfig.rb",
        "mkdir -p #{settings[:datadir]}/doc",
        "cp #{target_dir}/rbconfig.rb #{settings[:datadir]}/doc/rbconfig-2.4.4-orig.rb",
        "cp ../rbconfig-244-#{settings[:platform_triple]}.rb #{target_dir}/rbconfig.rb",
      ]
    end
  end
end
