component 'curl' do |pkg, settings, platform|
  pkg.version '7.88.1'
  pkg.sha256sum 'cdb38b72e36bc5d33d5b8810f8018ece1baa29a8f215b4495e495ded82bbf3c7'
  pkg.url "https://curl.se/download/curl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/curl-#{pkg.get_version}.tar.gz"

  pkg.build_requires "openssl-#{settings[:openssl_version]}"
  pkg.build_requires "puppet-ca-bundle"

  ldflags = settings[:ldflags]
  if platform.is_cross_compiled_linux?
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
    pkg.environment "PKG_CONFIG_PATH", "/opt/puppetlabs/puppet/lib/pkgconfig"
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
  elsif platform.is_windows?
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
    pkg.environment "CYGWIN", settings[:cygwin]
  elsif platform.is_aix? && platform.name != 'aix-7.1-ppc'
    pkg.environment "PKG_CONFIG_PATH", "/opt/puppetlabs/puppet/lib/pkgconfig"
    pkg.environment 'PATH', "/opt/freeware/bin:$(PATH):#{settings[:bindir]}"
    # exclude -Wl,-brtl
    ldflags = "-L#{settings[:libdir]}"
  else
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
  end

  # Following 3 lines should we removed once we upgrade CURL to 8.x.x
  pkg.apply_patch 'resources/patches/curl/CVE-2023-27535.patch'
  pkg.apply_patch 'resources/patches/curl/CVE-2023-28319.patch'
  pkg.apply_patch 'resources/patches/curl/CVE-2023-32001.patch'

  configure_options = []
  configure_options << "--with-ssl=#{settings[:prefix]}"

  # OpenSSL version 3.0 & up no longer ships by default the insecure algorithms
  # that curl's ntlm module depends on (md4 & des).
  if !settings[:use_legacy_openssl_algos] && settings[:openssl_version] =~ /^3\./
    configure_options << "--disable-ntlm"
  end

  extra_cflags = []
  if platform.is_cross_compiled? && platform.is_macos?
    extra_cflags << '-mmacosx-version-min=11.0 -arch arm64' if platform.name =~ /osx-11/
    extra_cflags << '-mmacosx-version-min=12.0 -arch arm64' if platform.name =~ /osx-12/
  end

  if (platform.is_solaris? && platform.os_version == '11') || platform.is_aix?
    # Makefile generation with automatic dependency tracking fails on these platforms
    configure_options << "--disable-dependency-tracking"
  end

  pkg.configure do
    ["CPPFLAGS='#{settings[:cppflags]}' \
      LDFLAGS='#{ldflags}' \
     ./configure --prefix=#{settings[:prefix]} \
        #{configure_options.join(" ")} \
        --enable-threaded-resolver \
        --disable-ldap \
        --disable-ldaps \
        --with-ca-bundle=#{settings[:prefix]}/ssl/cert.pem \
        --with-ca-path=#{settings[:prefix]}/ssl/certs \
        CFLAGS='#{settings[:cflags]} #{extra_cflags.join(" ")}' \
        #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  install_steps = [
    "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
  ]

  unless ['agent', 'pdk'].include?(settings[:runtime_project])
    # Most projects won't need curl binaries, so delete them after installation.
    # Note that the agent _should_ include curl binaries; Some projects and
    # scripts depend on them and they can be helpful in debugging.
    install_steps << "rm -f #{settings[:prefix]}/bin/{curl,curl-config}"
  end

  pkg.install do
    install_steps
  end
end
