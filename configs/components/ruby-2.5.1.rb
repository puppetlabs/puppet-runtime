component 'ruby-2.5.1' do |pkg, settings, platform|
  pkg.version '2.5.1'
  pkg.md5sum "23867bc8c16c55e43b14dfe0614bcfa8"

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
  # Configuration below should only be applicable to ruby 2.5.1

  #########
  # PATCHES
  #########

  base = 'resources/patches/ruby_251'
  pkg.apply_patch "#{base}/ostruct_remove_safe_nav_operator_r2.5.patch"
  pkg.apply_patch "#{base}/Check-for-existance-of-O_CLOEXEC.patch"
  # This patch creates our server/client shared Gem path, used for all gems
  # that are dependencies of the shared Ruby code.
  pkg.apply_patch "#{base}/rubygems_add_puppet_vendor_dir_r2.5.patch"

  if platform.is_cross_compiled?
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
  end

  ####################
  # ENVIRONMENT, FLAGS
  ####################

  if platform.is_macos? || platform.name =~ /^sles-11-i386/  # -O(>0) flags produce errors on 32-bit SLES 11 with GCC 4.8.2, see PA-2138
    pkg.environment 'optflags', settings[:cflags]
  elsif platform.is_windows?
    pkg.environment 'optflags', settings[:cflags] + ' -O3'
  elsif platform.is_cross_compiled?
    pkg.environment 'CROSS_COMPILING', 'true'
  else
    pkg.environment 'optflags', '-O2'
  end

  special_flags = " --prefix=#{ruby_dir} --with-opt-dir=#{settings[:prefix]} "

  if platform.is_aix?
    # This normalizes the build string to something like AIX 7.1.0.0 rather
    # than AIX 7.1.0.2 or something
    special_flags += " --build=#{settings[:platform_triple]} "
  elsif platform.is_cross_compiled_linux?
    special_flags += " --with-baseruby=#{host_ruby} "
  elsif platform.is_solaris? && platform.architecture == "sparc"
    special_flags += " --with-baseruby=#{host_ruby} --enable-close-fds-by-recvmsg-with-peek "
  elsif platform.is_windows?
    special_flags = " CPPFLAGS='-DFD_SETSIZE=2048' debugflags=-g --prefix=#{ruby_dir} --with-opt-dir=#{settings[:prefix]} "
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
    'powerpc-ibm-aix6.1.0.0' => 'powerpc-aix6.1.0.0',
    'aarch64-redhat-linux' => 'aarch64-linux',
    'ppc64-redhat-linux' => 'powerpc64-linux',
    'ppc64le-redhat-linux' => 'powerpc64le-linux',
    'powerpc64le-suse-linux' => 'powerpc64le-linux',
    'powerpc64le-linux-gnu' => 'powerpc64le-linux',
    's390x-linux-gnu' => 's390x-linux',
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
    rbconfig_changes["CC"] = "gcc"
    rbconfig_changes["warnflags"] = "-Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wno-tautological-compare -Wno-parentheses-equality -Wno-constant-logical-operand -Wno-self-assign -Wunused-variable -Wimplicit-int -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration -Wdeprecated-declarations -Wno-packed-bitfield-compat -Wsuggest-attribute=noreturn -Wsuggest-attribute=format -Wno-maybe-uninitialized"
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

  unless rbconfig_changes.empty?
    pkg.install do
      [
        "#{host_ruby} ../rbconfig-update.rb \"#{rbconfig_changes.to_s.gsub('"', '\"')}\" #{rbconfig_topdir}",
        "cp original_rbconfig.rb #{settings[:datadir]}/doc/rbconfig-2.5.1-orig.rb",
        "cp new_rbconfig.rb #{rbconfig_topdir}/rbconfig.rb",
      ]
    end
  end
end
