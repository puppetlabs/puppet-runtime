component 'augeas' do |pkg, settings, platform|
  # Projects may define an :augeas_version setting, or we use 1.8.1 by default:
  version = settings[:augeas_version] || '1.8.1'
  pkg.version version

  case version
    when '1.4.0'
      pkg.md5sum 'a2536a9c3d744dc09d234228fe4b0c93'

      pkg.apply_patch 'resources/patches/augeas/augeas-1.4.0-osx-stub-needed-readline-functions.patch'
      pkg.apply_patch 'resources/patches/augeas/augeas-1.4.0-sudoers-negated-command-alias.patch'
      pkg.apply_patch 'resources/patches/augeas/augeas-1.4.0-src-pathx.c-parse_name-correctly-handle-trailing-ws.patch'
    when '1.8.1'
      pkg.md5sum '623ff89d71a42fab9263365145efdbfa'
    when '1.10.1'
      pkg.md5sum '6c0b2ea6eec45e8bc374b283aedf27ce'

      if platform.name =~ /^el-(5|6|7)-.*/ || platform.is_fedora?
        # Augeas 1.10.1 needs a libselinux pkgconfig file on these platforms:
        pkg.build_requires 'ruby-selinux'
      elsif platform.name =~ /solaris-10-sparc/
        # This patch to gnulib fixes a linking error around symbol versioning in pthread.
        pkg.add_source 'file://resources/patches/augeas/augeas-1.10.1-gnulib-pthread-in-use.patch'

        pkg.configure do
          # gnulib is a submodule, and its files don't exist until after configure,
          # so we apply the patch manually here instead of using pkg.apply_patch.
          ["/usr/bin/gpatch -p0 < ../augeas-1.10.1-gnulib-pthread-in-use.patch"]
        end
      end
    else
      raise "augeas version #{version} has not been configured; Cannot continue."
  end

  pkg.url "http://download.augeas.net/augeas-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/augeas-#{pkg.get_version}.tar.gz"

  pkg.build_requires "libxml2"

  # Ensure we're building against our own libraries when present
  pkg.environment "PKG_CONFIG_PATH", "#{settings[:libdir]}/pkgconfig"

  if platform.is_aix?
        # We still use pl-gcc for AIX 7.1
    pkg.environment "CC", "/opt/pl-build-tools/bin/gcc"
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", "-I#{settings[:includedir]}"
    pkg.build_requires 'libedit'
  end

  if platform.is_rpm? && !platform.is_aix?
    if platform.architecture =~ /aarch64|ppc64le|s390x/
      pkg.build_requires "runtime-#{settings[:runtime_project]}"
      pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
      pkg.environment "CFLAGS", settings[:cflags]
      pkg.environment "LDFLAGS", settings[:ldflags]
    end
  elsif platform.is_deb?
    if platform.name =~ /debian-9/
      pkg.requires 'libreadline7'
    else
      pkg.requires 'libreadline6'
    end

    if platform.is_cross_compiled_linux?
      pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
      pkg.environment "CFLAGS", settings[:cflags]
      pkg.environment "LDFLAGS", settings[:ldflags]
    end

  elsif platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:#{settings[:bindir]}"
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.build_requires 'libedit'
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    if platform.os_version == "10"
      pkg.environment "PKG_CONFIG_PATH", "/opt/csw/lib/pkgconfig"
      pkg.environment "PKG_CONFIG", "/opt/csw/bin/pkg-config"
    else
      pkg.environment "PKG_CONFIG_PATH", "/usr/lib/pkgconfig"
      pkg.environment "PKG_CONFIG", "/opt/pl-build-tools/bin/pkg-config"
    end
  elsif platform.is_macos?
    pkg.environment "PATH" => "$$PATH:/usr/local/bin"
    pkg.environment "CFLAGS" => settings[:cflags]
  end

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end
