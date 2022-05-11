component 'ruby-2.5.9' do |pkg, settings, platform|
  pkg.version '2.5.9'
  pkg.md5sum '5c8f3634d80aff7c971aa264c313c5ba'

  # rbconfig-update is used to munge rbconfigs after the fact.
  pkg.add_source("file://resources/files/ruby/rbconfig-update.rb")

  # PDK packages multiple rubies and we need to tweak some settings
  # if this is not the *primary* ruby.
  if (pkg.get_version != settings[:ruby_version])
    # not primary ruby

    # ensure we have config for this ruby
    unless settings.has_key?(:additional_rubies) && settings[:additional_rubies].has_key?(pkg.get_version)
      raise "missing config for additional ruby #{pkg.get_version}"
    end

    ruby_settings = settings[:additional_rubies][pkg.get_version]

    ruby_dir = ruby_settings[:ruby_dir]
    ruby_bindir = ruby_settings[:ruby_bindir]
    host_ruby = ruby_settings[:host_ruby]
  else
    # primary ruby
    ruby_dir = settings[:ruby_dir]
    ruby_bindir = settings[:ruby_bindir]
    host_ruby = settings[:host_ruby]
  end

  # Most ruby configuration happens in the base ruby config:
  instance_eval File.read('configs/components/_base-ruby.rb')
  # Configuration below should only be applicable to ruby 2.5

  #########
  # PATCHES
  #########

  base = 'resources/patches/ruby_25'
  pkg.apply_patch "#{base}/ostruct_remove_safe_nav_operator_r2.5.patch"
  pkg.apply_patch "#{base}/Check-for-existance-of-O_CLOEXEC.patch"
  # Fix errant document end markers in libyaml 0.1.7; This is fixed in later versions
  pkg.apply_patch "#{base}/libyaml_document_end_r2.5.patch"
  # Patch for https://bugs.ruby-lang.org/issues/14972
  pkg.apply_patch "#{base}/net_http_eof_14972_r2.5.patch"
  pkg.apply_patch "#{base}/date-parsing-method-regexp-dos-cve-2021-41817.patch", fuzz: 1
  pkg.apply_patch "#{base}/buffer_overrun_string-to-float_conversion.patch"

  if platform.is_cross_compiled? && !platform.is_macos?
    pkg.apply_patch "#{base}/uri_generic_remove_safe_nav_operator_r2.5.patch"
    if platform.name =~ /^solaris-10-sparc/
      pkg.apply_patch "#{base}/Solaris-only-Replace-reference-to-RUBY-var-with-opt-pl-build-tool.patch"
    else
      pkg.apply_patch "#{base}/Replace-reference-to-RUBY-var-with-opt-pl-build-tool.patch"
    end
  end

  if platform.is_aix?
    # TODO: Remove this patch once PA-1607 is resolved.
    pkg.apply_patch "#{base}/aix_configure.patch"
    pkg.apply_patch "#{base}/aix-fix-libpath-in-configure.patch"
    pkg.apply_patch "#{base}/aix_use_pl_build_tools_autoconf_r2.5.patch"
    pkg.apply_patch "#{base}/aix_ruby_2.1_fix_make_test_failure_r2.5.patch"
    pkg.apply_patch "#{base}/Remove-O_CLOEXEC-check-for-AIX-builds_r2.5.patch"
  end

  if platform.is_windows?
    pkg.apply_patch "#{base}/windows_ruby_2.5_fixup_generated_batch_files.patch"
    pkg.apply_patch "#{base}/windows_socket_compat_error_r2.5.patch"
    pkg.apply_patch "#{base}/windows_nocodepage_utf8_fallback_r2.5.patch"
    pkg.apply_patch "#{base}/windows_env_block_size_limit.patch"
    pkg.apply_patch "#{base}/win32_long_paths_support.patch"
  end

  ####################
  # ENVIRONMENT, FLAGS
  ####################

  if platform.is_cross_compiled?
    pkg.environment 'CROSS_COMPILING', 'true'
    pkg.environment 'optflags', '-DUSE_FFI_CLOSURE_ALLOC' if platform.is_macos?
  elsif platform.is_macos? || platform.name =~ /^sles-11-i386/  # -O(>0) flags produce errors on 32-bit SLES 11 with GCC 4.8.2, see PA-2138
    pkg.environment 'optflags', settings[:cflags]
  elsif platform.is_windows?
    pkg.environment 'optflags', settings[:cflags] + ' -O3'
  else
    pkg.environment 'optflags', '-O2'
  end

  special_flags = " --prefix=#{ruby_dir} --with-opt-dir=#{settings[:prefix]} "

  if platform.name =~ /sles-15|el-8|debian-10/ || platform.is_fedora?
    special_flags += " CFLAGS='#{settings[:cflags]}' LDFLAGS='#{settings[:ldflags]}' CPPFLAGS='#{settings[:cppflags]}' "
  end

  if platform.is_aix?
    # This normalizes the build string to something like AIX 7.1.0.0 rather
    # than AIX 7.1.0.2 or something
    special_flags += " --build=#{settings[:platform_triple]} "
  elsif platform.is_cross_compiled? && (platform.is_linux? || platform.is_macos?)
    special_flags += " --with-baseruby=#{host_ruby} "
  elsif platform.is_solaris? && platform.architecture == "sparc"
    special_flags += " --with-baseruby=#{host_ruby} --enable-close-fds-by-recvmsg-with-peek "
  elsif platform.is_windows?
    special_flags = " CPPFLAGS='-DFD_SETSIZE=2048' debugflags=-g --prefix=#{ruby_dir} --with-opt-dir=#{settings[:prefix]} "
  end

  without_dtrace = [
    'aix-7.1-ppc',
    'el-7-ppc64le',
    'el-7-aarch64',
    'osx-11-arm64',
    'osx-12-arm64',
    'redhatfips-7-x86_64',
    'sles-11-x86_64',
    'sles-11-i386',
    'sles-12-ppc64le',
    'solaris-10-sparc',
    'solaris-11-sparc',
    'ubuntu-14.04-amd64',
    'ubuntu-14.04-i386',
    'ubuntu-16.04-ppc64el',
    'windows-2012r2-x64',
    'windows-2012r2-x86',
    'windows-2019-x64',
    'windowsfips-2012r2-x64'
  ]

  unless without_dtrace.include? platform.name
    special_flags += ' --enable-dtrace '
  end

  ###########
  # CONFIGURE
  ###########

  # TODO: Remove this once PA-1607 is resolved.
  # TODO: Can we use native autoconf? The dependencies seemed a little too extensive
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

  if platform.is_windows?
    # With ruby 2.5, ruby will generate cmd files instead of bat files; These
    # cmd wrappers work fine in our environment if they're just renamed as batch
    # files. Rake is omitted here on purpose - it retains the old batch wrapper.
    #
    # Note that this step must happen after the install step above.
    pkg.install do
      %w{erb gem irb rdoc ri}.map do |name|
        "mv #{ruby_bindir}/#{name}.cmd #{ruby_bindir}/#{name}.bat"
      end
    end
  end

  target_doubles = {
    'powerpc-ibm-aix7.1.0.0' => 'powerpc-aix7.1.0.0',
    'aarch64-apple-darwin' => 'aarch64-darwin',
    'aarch64-redhat-linux' => 'aarch64-linux',
    'ppc64-redhat-linux' => 'powerpc64-linux',
    'ppc64le-redhat-linux' => 'powerpc64le-linux',
    'powerpc64le-suse-linux' => 'powerpc64le-linux',
    'powerpc64le-linux-gnu' => 'powerpc64le-linux',
    'i386-pc-solaris2.10' => 'i386-solaris2.10',
    'sparc-sun-solaris2.10' => 'sparc-solaris2.10',
    'i386-pc-solaris2.11' => 'i386-solaris2.11',
    'sparc-sun-solaris2.11' => 'sparc-solaris2.11',
    'arm-linux-gnueabihf' => 'arm-linux-eabihf',
    'arm-linux-gnueabi' => 'arm-linux-eabi',
    'x86_64-w64-mingw32' => 'x64-mingw32',
    'i686-w64-mingw32' => 'i386-mingw32'
  }
  if target_doubles.has_key?(settings[:platform_triple])
    rbconfig_topdir = File.join(ruby_dir, 'lib', 'ruby', '2.5.0', target_doubles[settings[:platform_triple]])
  else
    rbconfig_topdir = "$$(#{ruby_bindir}/ruby -e \"puts RbConfig::CONFIG[\\\"topdir\\\"]\")"
  end

  rbconfig_changes = {}
  if platform.is_aix?
    rbconfig_changes["CC"] = "gcc"
  elsif platform.is_cross_compiled? || platform.is_solaris?
    if platform.name =~ /osx-11/
      rbconfig_changes["CC"] = 'clang -target arm64-apple-macos11'
    elsif platform.name =~ /osx-12/
      rbconfig_changes["CC"] = 'clang -target arm64-apple-macos12'
    else
      rbconfig_changes["CC"] = "gcc"
      rbconfig_changes["warnflags"] = "-Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wno-tautological-compare -Wno-parentheses-equality -Wno-constant-logical-operand -Wno-self-assign -Wunused-variable -Wimplicit-int -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration -Wdeprecated-declarations -Wno-packed-bitfield-compat -Wsuggest-attribute=noreturn -Wsuggest-attribute=format -Wno-maybe-uninitialized"
    end
    if platform.name =~ /el-7-ppc64/
      # EL 7 on POWER will fail with -Wl,--compress-debug-sections=zlib so this
      # will remove that entry
      # Matches both endians
      rbconfig_changes["DLDFLAGS"] = "-Wl,-rpath=/opt/puppetlabs/puppet/lib -L/opt/puppetlabs/puppet/lib  -Wl,-rpath,/opt/puppetlabs/puppet/lib"
    elsif platform.name =~ /solaris-10-sparc/
      # ld on solaris 10 sparc does not understand `-Wl,-E` - this is what remains after removing it:
      rbconfig_changes["LDFLAGS"] = "-L. -Wl,-rpath=/opt/puppetlabs/puppet/lib -fstack-protector"
      # `-Wl,--compress-debug-sections=zlib` is also a problem here:
      rbconfig_changes["DLDFLAGS"] = "-Wl,-rpath=/opt/puppetlabs/puppet/lib"
    end
  elsif platform.is_windows?
    rbconfig_changes["CC"] = "x86_64-w64-mingw32-gcc"
  end

  pkg.add_source("file://resources/files/ruby_vendor_gems/operating_system.rb")
  defaults_dir = File.join(settings[:libdir], "ruby/2.5.0/rubygems/defaults")
  pkg.directory(defaults_dir)
  pkg.install_file "../operating_system.rb", File.join(defaults_dir, 'operating_system.rb')

  certs_dir = File.join(settings[:libdir], 'ruby/2.5.0/rubygems/ssl_certs/puppetlabs.net')
  pkg.directory(certs_dir)

  pkg.add_source('file://resources/files/rubygems/COMODO_RSA_Certification_Authority.pem')
  pkg.install_file '../COMODO_RSA_Certification_Authority.pem', File.join(certs_dir, 'COMODO_RSA_Certification_Authority.pem')

  pkg.add_source('file://resources/files/rubygems/GlobalSignRootCA_R3.pem')
  pkg.install_file '../GlobalSignRootCA_R3.pem', File.join(certs_dir, 'GlobalSignRootCA_R3.pem')

  unless rbconfig_changes.empty?
    pkg.install do
      [
        "#{host_ruby} ../rbconfig-update.rb \"#{rbconfig_changes.to_s.gsub('"', '\"')}\" #{rbconfig_topdir}",
        "cp original_rbconfig.rb #{settings[:datadir]}/doc/rbconfig-#{pkg.get_version}-orig.rb",
        "cp new_rbconfig.rb #{rbconfig_topdir}/rbconfig.rb",
      ]
    end
  end
end
