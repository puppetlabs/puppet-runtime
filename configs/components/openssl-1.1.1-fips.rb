component 'openssl-1.1.1-fips' do |pkg, settings, platform|
  pkg.version '1.1.1k-6'
  pkg.sha256sum 'da536944410a0cbf5c0b6ee0b8f3ec62a9121be3b72bf2819bb4395a761662aa'
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

  # FIXME: pkg.apply_patch is not useful here as vanagon component does
  # not know how to extract rpm and patch happend before configure step
  # proper fix would be extension in vanagon for source rpm handling
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-patch-openssl-cnf.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-force-fips-mode.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-spec-file.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-remove-env-check.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1l-sm2-plaintext.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1k-CVE-2023-3446-fips.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1k-CVE-2023-5678-fips.patch'
  pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1k-CVE-2024-0727-fips.patch'

  if platform.name =~ /-7-/
    pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-post-rand.patch'
    pkg.add_source 'file://resources/patches/openssl/openssl-1.1.1-fips-edk2-build.patch'
  end

  topdir = "--define \"_topdir `pwd`/openssl-#{pkg.get_version}\""
  libdir = "--define '%_libdir %{_prefix}/lib'"
  prefix = "--define '%_prefix #{settings[:prefix]}'"

  pkg.configure do
    [
      "rpm -i #{topdir} openssl-#{pkg.get_version}.el8.src.rpm"
    ]
  end

  if platform.name =~ /-7-/
    pkg.configure do
      [
        "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-edk2-build.patch && cd -",
        "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-post-rand.patch && cd -",
      ]
    end
  end

  pkg.configure do
    [
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-patch-openssl-cnf.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-force-fips-mode.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-spec-file.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1-fips-remove-env-check.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1l-sm2-plaintext.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1k-CVE-2023-3446-fips.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1k-CVE-2023-5678-fips.patch && cd -",
      "cd openssl-#{pkg.get_version} && /usr/bin/patch --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../openssl-1.1.1k-CVE-2024-0727-fips.patch && cd -"
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
      # This chmod command is a work around, once we're off 1.1.1k-6 for openssl the below should be patched and we can remove the below line (PA-4621)
      "chmod -x #{settings[:prefix]}/bin/c_rehash",
      'if [ -f /etc/system-fips ]; then mv /etc/system-fips /etc/system-fips.off; fi',
      "/usr/bin/strip #{settings[:prefix]}/lib/libcrypto.so.1.1 && LD_LIBRARY_PATH=. crypto/fips/fips_standalone_hmac #{settings[:prefix]}/lib/libcrypto.so.1.1 > #{settings[:prefix]}/lib/.libcrypto.so.1.1.hmac",
      "/usr/bin/strip #{settings[:prefix]}/lib/libssl.so.1.1    && LD_LIBRARY_PATH=. crypto/fips/fips_standalone_hmac #{settings[:prefix]}/lib/libssl.so.1.1    > #{settings[:prefix]}/lib/.libssl.so.1.1.hmac",
      'if [ -f /etc/system-fips.off ]; then mv /etc/system-fips.off /etc/system-fips; fi'
    ]
  end
end
