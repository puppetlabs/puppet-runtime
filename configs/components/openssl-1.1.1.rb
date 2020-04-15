component 'openssl' do |pkg, settings, platform|
  pkg.version '1.1.1f'
  pkg.sha256sum '186c6bfe6ecfba7a5b48c47f8a1673d0f3b0e5ba2e25602dd23b629975da3f35'
  pkg.url "https://openssl.org/source/openssl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  # make sure openssl-lib compiles first, as we it only installs versioned libs and hopefully will not cause problems
  # the other way around caused: # error "Inconsistency between crypto.h and cryptlib.c"
  if settings[:provide_ssllib] && platform.is_linux?
    pkg.build_requires 'openssl-lib'
  end

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
    pkg.environment 'PATH', "/opt/pl-build-tools/bin:$$PATH"
    pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"

    cflags = "#{settings[:cflags]} -fPIC"
    if platform.architecture =~ /aarch/
      # OpenSSL fails to work on aarch unless we turn down the compiler optimization.
      # See PA-2135 for details
      cflags += " -O2"
    end

    ldflags = "-Wl,-rpath=/opt/pl-build-tools/#{settings[:platform_triple]}/lib -Wl,-rpath=#{settings[:libdir]} -L/opt/pl-build-tools/#{settings[:platform_triple]}/lib"
    target = if platform.architecture == 'aarch64'
                'linux-aarch64'
              elsif platform.name =~ /debian-8-arm/
                'linux-armv4'
              elsif platform.architecture =~ /ppc64le|ppc64el/ # Little-endian
                'linux-ppc64le'
              elsif platform.architecture =~ /ppc64/ # Big-endian
                'linux-ppc64'
              end
  elsif platform.is_aix?
    pkg.environment 'CC', '/opt/pl-build-tools/bin/gcc'

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
    elsif platform.architecture =~ /64$/
      target = 'linux-x86_64'
    end
  end

  ####################
  # BUILD REQUIREMENTS
  ####################

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  ###########
  # CONFIGURE
  ###########

  if platform.is_solaris? && platform.name =~ /10/
    # We need to link the rt library on Solaris 10 in order to access the clock_gettime
    # function.
    cflags += " -lrt"

    # Additionally when we're building on SPARC, we need to revert
    # https://github.com/openssl/openssl/commit/7a061312 because for
    # some reason, the linker fails to generate the .map files (like
    # e.g. libcrypto.map). Strangely, this is not an issue for Solaris
    # 11 SPARC despite it using an older version of ld (2.25 vs. 2.27).
    if platform.is_cross_compiled?
      pkg.apply_patch 'resources/patches/openssl/openssl-1.1.1a-revert-7a061312.patch'
    end
  end

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
    'no-camellia',
    'no-ec2m',
    'no-md2',
    'no-ssl3'
  ]

  # Individual projects may provide their own openssl configure flags:
  project_flags = settings[:openssl_extra_configure_flags] || []
  perl_exec = ''
  if platform.is_aix?
    perl_exec = '/opt/freeware/bin/perl'
  elsif platform.is_solaris? && platform.os_version == '10'
    perl_exec = '/opt/csw/bin/perl'
  end
  configure_flags << project_flags << cflags << ldflags

  pkg.configure do
    ["#{perl_exec} ./Configure #{configure_flags.join(' ')}"]
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
