component 'openssl-fips-2.0.16' do |pkg, settings, platform|
  pkg.md5sum '55ef09f12bb199d47e6a84e79fb959d7'
  pkg.url 'https://www.openssl.org/source/openssl-fips-2.0.16.tar.gz'

  if platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
    pkg.environment 'CYGWIN', settings[:cygwin]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CXX', settings[:cxx]
    pkg.environment 'MAKE', platform[:make]
    pkg.environment 'SYSTEM', 'mingw64'
    pkg.environment 'INSTALL_PREFIX', settings[:prefix]
  end

  if platform.is_windows?
    pkg.apply_patch 'resources/patches/openssl/openssl-fips-2.0.16.patch'
  end

  pkg.configure do
    ["./config no-asm"]
  end

  pkg.build do
    ['/usr/bin/make ']
  end

  pkg.install do
    ['/usr/bin/make install']
  end
end
