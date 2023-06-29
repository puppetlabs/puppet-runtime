component 'openssl' do |pkg, settings, platform|
  pkg.version '3.0.9'
  pkg.sha256sum 'eb1ab04781474360f77c318ab89d8c5a03abc38e63d65a603cabbf1b00a1dc90'
  pkg.url "https://openssl.org/source/openssl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  if platform.name =~ /^(el-|redhat-|redhatfips-|fedora-)/
    pkg.build_requires 'perl-core'
  elsif platform.is_windows?
    pkg.build_requires 'strawberryperl'
  elsif platform.is_solaris?
    # perl is installed in platform definition
  else
    pkg.build_requires 'perl'
  end

  target = sslflags = ''
  cflags = settings[:cflags]
  ldflags = settings[:ldflags]

  if platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
    pkg.environment 'CYGWIN', settings[:cygwin]
    pkg.environment 'MAKE', platform[:make]

    target = platform.architecture == 'x64' ? 'mingw64' : 'mingw'
  # elsif platform.is_cross_compiled_linux?
  #   pkg.environment 'PATH', "/opt/pl-build-tools/bin:$(PATH)"
  #   pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"

  #   cflags = "#{settings[:cflags]} -fPIC"
  #   if platform.architecture =~ /aarch/
  #     # OpenSSL fails to work on aarch unless we turn down the compiler optimization.
  #     # See PA-2135 for details
  #     cflags += " -O2"
  #   end
  #   ldflags = "-Wl,-rpath=/opt/pl-build-tools/#{settings[:platform_triple]}/lib -Wl,-rpath=#{settings[:libdir]} -L/opt/pl-build-tools/#{settings[:platform_triple]}/lib"
  #   target = if platform.architecture == 'aarch64'
  #               'linux-aarch64'
  #             elsif platform.name =~ /debian-8-arm/
  #               'linux-armv4'
  #             elsif platform.architecture =~ /ppc64le|ppc64el/ # Little-endian
  #               'linux-ppc64le'
  #             elsif platform.architecture =~ /ppc64/ # Big-endian
  #               'linux-ppc64'
  #             end
  elsif platform.is_aix?
    raise "openssl-3.0 is not supported on older AIX" if platform.name == 'aix-7.1-ppc'

    # REMIND: why not PATH?
    pkg.environment 'CC', '/opt/freeware/bin/gcc'

    cflags = "#{settings[:cflags]} -static-libgcc"
    # see https://github.com/openssl/openssl/issues/18007 about -latomic
    # see https://www.ibm.com/docs/en/aix/7.2?topic=l-ld-command about -R<path>, which is equivalent to -rpath
    ldflags = "#{settings[:ldflags]} -Wl,-R#{settings[:libdir]} -latomic -lm"
    target = 'aix-gcc'
  elsif platform.is_solaris?
    pkg.environment 'PATH', '/opt/csw/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin'
    pkg.environment 'CC', "/opt/csw/bin/#{settings[:platform_triple]}-gcc"

    cflags = "#{settings[:cflags]} -fPIC"
    ldflags = "-R/opt/csw/#{settings[:platform_triple]}/lib -Wl,-rpath=#{settings[:libdir]} -L/opt/csw/#{settings[:platform_triple]}/lib"
    target = platform.architecture =~ /86/ ? 'solaris-x86-gcc' : 'solaris-sparcv9-gcc'
  elsif platform.is_macos?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'

    target = if platform.is_cross_compiled?
               'darwin64-arm64'
             else
               'darwin64-x86_64'
             end
  elsif platform.is_linux?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'

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
    elsif platform.architecture == 'armhf'
      target = 'linux-armv4'
    end
  end

  ####################
  # BUILD REQUIREMENTS
  ####################

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  ###########
  # CONFIGURE
  ###########

  # Defining --libdir ensures that we avoid the multilib (lib/ vs. lib64/) problem,
  # since configure uses the existence of a lib64 directory to determine
  # if it should install its own libs into a multilib dir. Yay OpenSSL!
  configure_flags = [
    "--prefix=#{settings[:prefix]}",
    '--libdir=lib',
    "--openssldir=#{settings[:prefix]}/ssl",
    'shared',
    'no-gost',
    target,
    sslflags,
    'no-camellia',
    'no-md2',
    'no-ssl3',
    'no-ssl3-method',
    'no-dtls1-method',
    'no-dtls1_2-method',
    'no-aria',
    # 'no-bf', pgcrypto is requires this cipher in postgres for puppetdb
    # 'no-cast', pgcrypto is requires this cipher in postgres for puppetdb
    'no-rc5',
    # 'no-md4', puppet infra uses the agent's runtime and runs WinRM tasks using NTLM, so it needs DES & MD4
    'no-mdc2',
    # 'no-rmd160', this is causing failures with pxp, remove once pxp-agent does not need it
    'no-whirlpool',
    'no-legacy'
  ]

  # Individual projects may provide their own openssl configure flags:
  project_flags = settings[:openssl_extra_configure_flags] || []
  perl_exec = ''
  if platform.is_aix?
    perl_exec = '/opt/freeware/bin/perl'
  end
  configure_flags << project_flags

  pkg.environment 'CFLAGS', cflags
  pkg.environment 'LDFLAGS', ldflags
  pkg.configure do
    ["#{perl_exec} ./Configure #{configure_flags.join(' ')}"]
  end

  #######
  # BUILD
  #######

  build_commands = []

  if platform.is_windows? && platform.architecture == "x86"
    # mingw-w32 5.2.0 has a bug in include/winnt.h that declares GetCurrentFiber
    # with __CRT_INLINE, which results in the function not being inlined and
    # generates a linker error: undefined reference to `GetCurrentFiber'.
    # This only affects 32-bit builds
    # See https://github.com/openssl/openssl/issues/513
    # See https://github.com/mingw-w64/mingw-w64/commit/8da1aae7a7ff5bf996878dc8fe30a0e01e210e5a
    pkg.add_source("file://resources/patches/windows/FORCEINLINE-i686-w64-mingw32-winnt.h")
    build_commands << "#{platform.patch} --dir #{settings[:gcc_root]}/#{settings[:platform_triple]} --strip=2 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../FORCEINLINE-i686-w64-mingw32-winnt.h"
  end

  build_commands << "#{platform[:make]} depend"
  build_commands << "#{platform[:make]}"

  pkg.build do
    build_commands
  end

  #########
  # INSTALL
  #########

  install_prefix = platform.is_windows? ? '' : 'INSTALL_PREFIX=/'
  install_commands = []

  if platform.is_aix?
    # "Removes any currently unused modules in kernel and library memory."
    install_commands << "slibclean"
  end

  # Skip man and html docs
  install_commands << "#{platform[:make]} #{install_prefix} install_sw install_ssldirs"

  # if settings[:runtime_project] == 'pdk'
  #   install_commands << "rm -f #{settings[:prefix]}/bin/{openssl,c_rehash}"
  # end

  install_commands << "rm -f #{settings[:prefix]}/bin/c_rehash"

  pkg.install do
    install_commands
  end

  pkg.install_file 'LICENSE.txt', "#{settings[:prefix]}/share/doc/openssl-#{pkg.get_version}/LICENSE"
end

