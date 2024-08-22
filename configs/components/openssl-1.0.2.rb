component 'openssl' do |pkg, settings, platform|
  pkg.version '1.0.2u'
  pkg.md5sum 'cdc2638f789ecc2db2c91488265686c1'
  pkg.url "https://openssl.org/source/openssl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  target = cflags = ldflags = sslflags = ''

  if platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
    pkg.environment 'CYGWIN', settings[:cygwin]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CXX', settings[:cxx]
    pkg.environment 'MAKE', platform[:make]

    target = platform.architecture == 'x64' ? 'mingw64' : 'mingw'
    cflags = settings[:cflags]
    ldflags = settings[:ldflags]
  elsif platform.is_cross_compiled_linux?
    pkg.environment 'PATH', "/opt/pl-build-tools/bin:$(PATH)"
    pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"

    cflags = "#{settings[:cflags]} -fPIC"
    ldflags = "-Wl,-rpath=/opt/pl-build-tools/#{settings[:platform_triple]}/lib -Wl,-rpath=#{settings[:libdir]} -L/opt/pl-build-tools/#{settings[:platform_triple]}/lib"
    target = if platform.architecture == 'aarch64'
               'linux-aarch64'
             elsif platform.architecture =~ /ppc64le|ppc64el/ # Litte-endian
               'linux-ppc64le'
             elsif platform.architecture =~ /ppc64/ # Big-endian
               'linux-ppc64'
             end
  elsif platform.is_aix?
    pkg.environment "CC", "/opt/pl-build-tools/bin/gcc"
    cflags = '$${CFLAGS} -static-libgcc'
    target = 'aix-gcc'
  elsif platform.is_solaris?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin'
    pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"

    cflags = "#{settings[:cflags]} -fPIC"
    ldflags = "-R/opt/pl-build-tools/#{settings[:platform_triple]}/lib -Wl,-rpath=#{settings[:libdir]} -L/opt/pl-build-tools/#{settings[:platform_triple]}/lib"
    target = platform.architecture =~ /86/ ? 'solaris-x86-gcc' : 'solaris-sparcv9-gcc'
  elsif platform.is_macos?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'

    cflags = settings[:cflags]
    target = 'darwin64-x86_64-cc'
  elsif platform.is_linux?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'

    cflags = settings[:cflags]
    ldflags = "#{settings[:ldflags]} -Wl,-z,relro"
    if platform.architecture =~ /86$/
      target = 'linux-elf'
      sslflags = '386'
    elsif platform.architecture =~ /aarch64$/
      target = 'linux-aarch64'
    elsif platform.architecture =~ /ppc64le|ppc64el/ # Little-endian
      target = 'linux-ppc64le'
    elsif platform.architecture =~ /64$/
      target = 'linux-x86_64'
    end
  end

  ####################
  # BUILD REQUIREMENTS
  ####################

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  #########
  # PATCHES
  #########

  if platform.is_windows?
    pkg.apply_patch 'resources/patches/openssl/openssl-1.0.0l-use-gcc-instead-of-makedepend.patch'
    # This patch removes the option `-DOPENSSL_USE_APPLINK` from the mingw openssl congifure target
    # This brings mingw more in line with what is happening with mingw64. All applink does it makes
    # it possible to use the .dll compiled with one compiler with an application compiled with a
    # different compiler. Given our openssl should only be interacting with things that we build,
    # we can ensure everything is build with the same compiler.
    pkg.apply_patch 'resources/patches/openssl/openssl-mingw-do-not-build-applink.patch'
    pkg.apply_patch 'resources/patches/openssl/openssl-enforce-fips-on-fips-mode.patch'
    pkg.apply_patch 'resources/patches/openssl/openssl-low-level-access.patch'
    pkg.apply_patch 'resources/patches/openssl/openssl-expose-drbg-init.patch'
  elsif platform.is_aix?
    pkg.apply_patch 'resources/patches/openssl/add-shell-to-engines_makefile.patch'
    pkg.apply_patch 'resources/patches/openssl/openssl-1.0.0l-use-gcc-instead-of-makedepend.patch'
  elsif platform.is_solaris?
    pkg.apply_patch 'resources/patches/openssl/add-shell-to-engines_makefile.patch'
    pkg.apply_patch 'resources/patches/openssl/openssl-1.0.0l-use-gcc-instead-of-makedepend.patch'
  end
  pkg.apply_patch 'resources/patches/openssl/CVE-2020-1968.patch'
  pkg.apply_patch 'resources/patches/openssl/CVE-2020-1971.patch'
  pkg.apply_patch 'resources/patches/openssl/CVE-2021-23839.patch'
  pkg.apply_patch 'resources/patches/openssl/CVE-2021-23840.patch'
  pkg.apply_patch 'resources/patches/openssl/CVE-2021-23841.patch'
  pkg.apply_patch 'resources/patches/openssl/CVE-2021-3712.patch'

  ###########
  # CONFIGURE
  ###########

  # OpenSSL Configure doesn't honor CFLAGS or LDFLAGS as environment variables.
  # Instead, those should be passed to Configure at the end of its options, as
  # any unrecognized options are passed straight through to ${CC}. Defining
  # --libdir ensures that we avoid the multilib (lib/ vs. lib64/) problem,
  # since configure uses the existence of a lib64 directory to determine
  # if it should install its own libs into a multilib dir. Yay OpenSSL!
  configure_flags = [
    "--prefix=#{settings[:prefix]}",
    '--libdir=lib',
    "--openssldir=#{settings[:prefix]}/ssl",
    'shared',
    'no-asm',
    target,
    sslflags,
    'enable-rfc3779',
    'enable-tlsext',
    'no-camellia',
    'no-ec2m',
    'no-md2',
    'no-mdc2',
    'no-ssl2',
    'no-ssl3',
  ]

  configure_flags += ['fips', "--with-fipsdir=#{settings[:prefix]}/usr/local/ssl/fips-2.0"] if platform.name =~ /windowsfips-/

  # Individual projects may provide their own openssl configure flags:
  project_flags = settings[:openssl_extra_configure_flags] || []
  configure_flags << project_flags << cflags << ldflags

  pkg.configure do
    ["./Configure #{configure_flags.join(' ')}"]
  end

  #######
  # BUILD
  #######

  pkg.build do
    [
      "#{platform[:make]} depend",
      "#{platform[:make]}"
    ]
  end

  #########
  # INSTALL
  #########

  install_prefix = platform.is_windows? ? '' : 'INSTALL_PREFIX=/'
  install_commands = []

  if platform.is_aix?
    install_commands << "slibclean"
  end

  install_commands << "#{platform[:make]} #{install_prefix} install"

  if settings[:runtime_project] == 'pdk'
    install_commands << "rm -f #{settings[:prefix]}/bin/{openssl,c_rehash}"
  end

  pkg.install do
    install_commands
  end

  pkg.install_file 'LICENSE', "#{settings[:prefix]}/share/doc/openssl-#{pkg.get_version}/LICENSE"
end
