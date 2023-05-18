component 'openssl' do |pkg, settings, platform|
  pkg.version '3.0.8'
  pkg.sha256sum '6c13d2bf38fdf31eac3ce2a347073673f5d63263398f1f69d0df4a41253e4b3e'
  pkg.url "https://openssl.org/source/openssl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  if platform.name =~ /^(el-|redhat-|redhatfips-|fedora-)/
    pkg.build_requires 'perl-core'
  elsif platform.is_windows?
    pkg.build_requires 'strawberryperl'
  else
    pkg.build_requires 'perl'
  end

  target = cflags = ldflags = sslflags = ''

 if platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
  #   pkg.environment 'CYGWIN', settings[:cygwin]
  #   pkg.environment 'CC', settings[:cc]
  #   pkg.environment 'CXX', settings[:cxx]
  #   pkg.environment 'MAKE', platform[:make]

    target = platform.architecture == 'x64' ? 'mingw64' : 'mingw'
  #   cflags = settings[:cflags]
  #   ldflags = settings[:ldflags]
  # elsif platform.is_cross_compiled_linux?
  #   pkg.environment 'PATH', "/opt/pl-build-tools/bin:$(PATH)"
  #   pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"

  #   cflags = "#{settings[:cflags]} -fPIC"
  #   if platform.architecture =~ /aarch/
  #     # OpenSSL fails to work on aarch unless we turn down the compiler optimization.
  #     # See PA-2135 for details
  #     cflags += " -O2"
   end

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
  # elsif platform.is_aix?
  #   pkg.environment 'CC', '/opt/pl-build-tools/bin/gcc'

  #   cflags = '$${CFLAGS} -static-libgcc'
  #   target = 'aix-gcc'
  # elsif platform.is_solaris?
  #   pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin'
  #   pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"

  #   cflags = "#{settings[:cflags]} -fPIC"
  #   ldflags = "-R/opt/pl-build-tools/#{settings[:platform_triple]}/lib -Wl,-rpath=#{settings[:libdir]} -L/opt/pl-build-tools/#{settings[:platform_triple]}/lib"
  #   target = platform.architecture =~ /86/ ? 'solaris-x86-gcc' : 'solaris-sparcv9-gcc'
  if platform.is_macos?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'

    cflags = settings[:cflags]
    target = if platform.is_cross_compiled?
               'darwin64-arm64'
             else
               'darwin64-x86_64'
             end
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
    'no-ec2m',
    'no-md2',
    'no-ssl3',
    'no-ssl3-method',
    'no-dtls1-method',
    'no-dtls1_2-method',
    'no-aria',
    'no-bf',
    'no-cast',
    'no-rc2',
    'no-rc5',
    'no-md4',
    'no-mdc2',
    'no-rmd160',
    'no-whirlpool',
    'no-legacy'
  ]

  # Individual projects may provide their own openssl configure flags:
  project_flags = settings[:openssl_extra_configure_flags] || []
  perl_exec = ''
  # if platform.is_aix?
  #   perl_exec = '/opt/freeware/bin/perl'
  # end
  configure_flags << project_flags

  pkg.environment 'CFLAGS', cflags
  pkg.environment 'LDFLAGS', ldflags
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

  # if platform.is_aix?
  #   install_commands << "slibclean"
  # end

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

