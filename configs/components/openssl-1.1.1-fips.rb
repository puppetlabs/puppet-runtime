component 'openssl-1.1.1-fips' do |pkg, settings, _platform|
  pkg.version '1.1.1k-4'
  pkg.sha256sum '9448292689f8d5e55d419500b16a5e9da980d55429d02531d75a99a1e4ec4cdc'
  pkg.url "https://vault.centos.org/centos/8-stream/BaseOS/Source/SPackages/openssl-#{pkg.get_version}.el8.src.rpm"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.el8.src.rpm"

  pkg.build_requires 'rpm-build'
  pkg.build_requires 'krb5-devel'
  pkg.build_requires 'zlib-devel'
  pkg.build_requires 'lksctp-tools-devel'
  pkg.build_requires 'perl-Test-Harness'
  pkg.build_requires 'perl-Module-Load-Conditional'

  patch_version = pkg.get_version.match(/\d\.\d\.\d(\w)/).captures.first
  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  # make sure openssl-lib compiles first, as it only installs versioned libs and hopefully will not cause problems
  # the other way around caused: # error "Inconsistency between crypto.h and cryptlib.c"
  if settings[:provide_ssllib] && platform.is_linux?
    pkg.build_requires 'openssl-lib'
  end

  # FIXME: pkg.apply_patch is not useful here as vanagon component does
  # not know how to extract rpm and patch happend before configure step
  # proper fix would be extension in vanagon for source rpm handling
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-patch-openssl-cnf.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-force-fips-mode.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-post-rand.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-spec-file.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-remove-env-check.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-edk2-build.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1l-ec-group-new-from-ecparameters.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1l-sm2-plaintext.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1l-remove-non-fips-ciphers.patch'

  topdir = "--define \"_topdir `pwd`/openssl-#{pkg.get_version}\""
  libdir = "--define '%_libdir %{_prefix}/lib'"
  prefix = "--define '%_prefix #{settings[:prefix]}'"

  pkg.configure do
    [
      "rpm -i #{topdir} openssl-#{pkg.get_version}.el8.src.rpm",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-patch-openssl-cnf.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-force-fips-mode.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-post-rand.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-spec-file.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-remove-env-check.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-edk2-build.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1l-ec-group-new-from-ecparameters.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1l-sm2-plaintext.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1l-remove-non-fips-ciphers.patch && cd -",
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
      "cd openssl-#{pkg.get_version}/BUILD/openssl-1.1.1#{patch_version} && make install",
      'if [ -f /etc/system-fips ]; then mv /etc/system-fips /etc/system-fips.off; fi',
      "/usr/bin/strip #{settings[:prefix]}/lib/libcrypto.so.1.1 && LD_LIBRARY_PATH=. crypto/fips/fips_standalone_hmac #{settings[:prefix]}/lib/libcrypto.so.1.1 > #{settings[:prefix]}/lib/.libcrypto.so.1.1.hmac",
      "/usr/bin/strip #{settings[:prefix]}/lib/libssl.so.1.1    && LD_LIBRARY_PATH=. crypto/fips/fips_standalone_hmac #{settings[:prefix]}/lib/libssl.so.1.1    > #{settings[:prefix]}/lib/.libssl.so.1.1.hmac",
      'if [ -f /etc/system-fips.off ]; then mv /etc/system-fips.off /etc/system-fips; fi'
    ]
  end
end
