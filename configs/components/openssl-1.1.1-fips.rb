component 'openssl-1.1.1-fips' do |pkg, settings, _platform|
  pkg.version '1.1.1c-2'
  pkg.sha256sum 'a5460ed338ea837e9ecc1475527f996317ffb61b99fc96ee873b4aceee4618bb'
  pkg.url "http://vault.centos.org/8.1.1911/BaseOS/Source/SPackages/openssl-#{pkg.get_version}.el8.src.rpm"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.el8.src.rpm"

  pkg.build_requires 'rpm-build'
  pkg.build_requires 'krb5-devel'
  pkg.build_requires 'zlib-devel'
  pkg.build_requires 'lksctp-tools-devel'
  pkg.build_requires 'perl-Test-Harness'
  pkg.build_requires 'perl-Module-Load-Conditional'

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  # make sure openssl-lib compiles first, as we it only installs versioned libs and hopefully will not cause problems
  # the other way around caused: # error "Inconsistency between crypto.h and cryptlib.c"
  if settings[:provide_ssllib] && platform.is_linux?
    pkg.build_requires 'openssl-lib'
  end

  # FIXME: pkg.apply_patch is not usefull here as vanagon component does
  # not know how to extract rpm and patch happend before configure step
  # proper fix would be extension in vanagon for source rpm handling
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-patch-openssl-cnf.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-force-fips-mode.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-post-rand.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-spec-file.patch'

  topdir = "--define \"_topdir `pwd`/openssl-#{pkg.get_version}\""
  libdir = "--define '%_libdir %{_prefix}/lib'"
  prefix = "--define '%_prefix #{settings[:prefix]}'"

  pkg.configure do
    [
      "rpm -i #{topdir} openssl-#{pkg.get_version}.el8.src.rpm",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-patch-openssl-cnf.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-force-fips-mode.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-post-rand.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-spec-file.patch && cd -"
    ]
  end

  pkg.build do
    [
      'if [ -f /etc/system-fips ]; then mv /etc/system-fips /etc/system-fips.off; fi',
      "rpmbuild -bc --nocheck #{libdir} #{prefix} #{topdir} openssl-#{pkg.get_version}/SPECS/openssl.spec",
      'if [ -f /etc/system-fips.off ]; then mv /etc/system-fips.off /etc/system-fips; fi'
    ]
  end

  pkg.install do
    [
      "cd openssl-#{pkg.get_version}/BUILD/openssl-1.1.1c && make install",
      'if [ -f /etc/system-fips ]; then mv /etc/system-fips /etc/system-fips.off; fi',
      "/usr/bin/strip #{settings[:prefix]}/lib/libcrypto.so.1.1 && LD_LIBRARY_PATH=. crypto/fips/fips_standalone_hmac #{settings[:prefix]}/lib/libcrypto.so.1.1 > #{settings[:prefix]}/lib/.libcrypto.so.1.1.hmac",
      "/usr/bin/strip #{settings[:prefix]}/lib/libssl.so.1.1    && LD_LIBRARY_PATH=. crypto/fips/fips_standalone_hmac #{settings[:prefix]}/lib/libssl.so.1.1    > #{settings[:prefix]}/lib/.libssl.so.1.1.hmac",
      'if [ -f /etc/system-fips.off ]; then mv /etc/system-fips.off /etc/system-fips; fi'
    ]
  end
end
