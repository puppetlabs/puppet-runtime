component "openssl" do |pkg, settings, platform|
  ## SOURCE METADATA
  pkg.version "1.0.2m"
  pkg.md5sum "10e9e37f492094b9ef296f68f24a7666"
  pkg.url "https://www.openssl.org/source/openssl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  ## PACKAGE DEPENDENCIES

  ## BUILD REQUIREMENTS
  if platform.is_windows?
    pkg.build_requires "runtime"
  elsif platform.is_linux?
    pkg.build_requires 'pl-binutils'
    pkg.build_requires 'pl-gcc'
  end

  ## BUILD CONFIGURATION
  install_prefix = "INSTALL_PREFIX=/" unless platform.is_windows?

  if platform.is_macos?
    target = 'darwin64-x86_64-cc'
    cflags = settings[:cflags]
    ldflags = ''
  elsif platform.is_windows?
    pkg.apply_patch 'resources/patches/openssl/openssl-1.0.0l-use-gcc-instead-of-makedepend.patch'
    pkg.apply_patch 'resources/patches/openssl/openssl-mingw-do-not-build-applink.patch'
    target = platform.architecture == "x64" ? "mingw64" : "mingw"
    pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
    pkg.environment "CYGWIN", settings[:cygwin]
    pkg.environment "CC", settings[:cc]
    pkg.environment "CXX", settings[:cxx]
    pkg.environment "MAKE", platform[:make]
    cflags = settings[:cflags]
    ldflags = settings[:ldflags]
  else # Linux Platforms
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin"
    target = 'linux-x86_64'
    cflags = settings[:cflags]
    ldflags = "#{settings[:ldflags]} -Wl,-z,relro"
  end

  ## BUILD COMMANDS
  pkg.configure do
    [# OpenSSL Configure doesn't honor CFLAGS or LDFLAGS as environment variables.
    # Instead, those should be passed to Configure at the end of its options, as
    # any unrecognized options are passed straight through to ${CC}. Defining
    # --libdir ensures that we avoid the multilib (lib/ vs. lib64/) problem,
    # since configure uses the existence of a lib64 directory to determine
    # if it should install its own libs into a multilib dir. Yay OpenSSL!
    "./Configure \
      --prefix=#{settings[:prefix]} \
      --libdir=lib \
      --openssldir=#{settings[:prefix]}/ssl \
      shared \
      no-asm \
      #{target} \
      no-camellia \
      enable-seed \
      enable-tlsext \
      enable-rfc3779 \
      enable-cms \
      no-md2 \
      no-mdc2 \
      no-rc5 \
      no-ec2m \
      no-gost \
      no-srp \
      no-ssl2 \
      no-ssl3 \
      #{cflags} \
      #{ldflags}"]
  end

  pkg.build do
    ["#{platform[:make]} depend",
    "#{platform[:make]}"]
  end

  pkg.install do
    ["#{platform[:make]} #{install_prefix} install",
     "rm -f #{settings[:prefix]}/bin/openssl",
     "rm -f #{settings[:prefix]}/bin/c_rehash",
    ]
  end

  pkg.install_file "LICENSE", "#{settings[:prefix]}/share/doc/openssl-#{pkg.get_version}/LICENSE"
end
