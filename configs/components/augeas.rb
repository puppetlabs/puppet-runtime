component 'augeas' do |pkg, settings, platform|
  # Projects may define an :augeas_version setting, or we use 1.8.1 by default:
  version = settings[:augeas_version] || '1.8.1'
  pkg.version version

  case version
  when '1.14.1'
    pkg.md5sum 'ac31216268b4b64809afd3a25f2515e5'
    pkg.url "https://github.com/hercules-team/augeas/releases/download/release-1.14.1/augeas-1.14.1.tar.gz"
  when '1.13.0'
    pkg.md5sum '909b9934190f32ffcbc2c5a92efaf9d2'
    pkg.url "https://github.com/hercules-team/augeas/releases/download/release-1.13.0/augeas-1.13.0.tar.gz"
    pkg.apply_patch 'resources/patches/augeas/augeas-1.13.0-patch_security_context-t_out.patch'
  when '1.8.1'
    pkg.md5sum '623ff89d71a42fab9263365145efdbfa'
  when '1.11.0'
    pkg.md5sum 'abf51f4c0cf3901d167f23687f60434a'
  when '1.12.0'
    pkg.md5sum '74f1c7b8550f4e728486091f6b907175'

    pkg.apply_patch 'resources/patches/augeas/augeas-1.12.0-allow-ad-groups-in-sudoers.patch'
    pkg.apply_patch 'resources/patches/augeas/augeas-1.12.0-allow-hyphen-postgresql-lens.patch'
  else
    raise "augeas version #{version} has not been configured; Cannot continue."
  end

  if ['1.11.0', '1.12.0', '1.13.0', '1.14.1'].include?(version)
    if platform.is_el? || platform.is_fedora?
      # Augeas 1.11.0 needs a libselinux pkgconfig file on these platforms:
      pkg.build_requires 'ruby-selinux'
    end

    if platform.name =~ /solaris-10-sparc/
      # This patch to gnulib fixes a linking error around symbol versioning in pthread.
      pkg.add_source "file://resources/patches/augeas/augeas-#{version}-gnulib-pthread-in-use.patch"
      pkg.configure do
        # gnulib is a submodule, and its files don't exist until after configure,
        # so we apply the patch manually here instead of using pkg.apply_patch.
        ["/usr/bin/gpatch -p0 < ../augeas-#{version}-gnulib-pthread-in-use.patch"]
      end
    end

    if platform.is_macos?
      pkg.build_requires 'readline'
      pkg.build_requires 'autoconf'
      pkg.build_requires 'automake'
      pkg.build_requires 'libtool'
    end

    extra_config_flags = platform.name =~ /solaris-11|aix/ ? " --disable-dependency-tracking" : ""
  end

  pkg.url "http://download.augeas.net/augeas-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/augeas-#{pkg.get_version}.tar.gz"

  pkg.build_requires "libxml2"

  # Ensure we're building against our own libraries when present
  pkg.environment "PKG_CONFIG_PATH", "#{settings[:libdir]}/pkgconfig"

  if platform.is_aix?
    if platform.name == 'aix-7.1-ppc'
      pkg.environment "CC", "/opt/pl-build-tools/bin/gcc"
    else
      pkg.environment "CC", "/opt/freeware/bin/gcc"
      pkg.environment "PATH", "/opt/freeware/bin:$(PATH):#{settings[:bindir]}"
    end
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    if platform.name == 'aix-7.1-ppc'
      pkg.build_requires 'libedit'
    else
      pkg.build_requires 'readline'
    end

    pkg.environment "LDFLAGS", settings[:ldflags]
    pkg.environment "CFLAGS", "-I#{settings[:includedir]}"
  end

  if platform.is_rpm? && !platform.is_aix?
    if platform.architecture =~ /aarch64|ppc64|ppc64le/
      pkg.build_requires "runtime-#{settings[:runtime_project]}"
      pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
      pkg.environment "CFLAGS", settings[:cflags]
      pkg.environment "LDFLAGS", settings[:ldflags]
    end
  elsif platform.is_deb?
    pkg.requires 'libreadline6'

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
    elsif !platform.is_cross_compiled? && platform.architecture == 'sparc'
      pkg.environment "PKG_CONFIG_PATH", "#{settings[:libdir]}/pkgconfig"
      pkg.environment "PKG_CONFIG", "/usr/bin/pkg-config"
    else
      pkg.environment "PKG_CONFIG_PATH", "/usr/lib/pkgconfig"
      pkg.environment "PKG_CONFIG", "/opt/pl-build-tools/bin/pkg-config"
    end
  elsif platform.is_macos?
    pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin:/usr/local/bin'
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment "LDFLAGS", settings[:ldflags]
    if platform.is_cross_compiled?
      pkg.environment 'CC', 'clang -target arm64-apple-macos11' if platform.name =~ /osx-11/
      pkg.environment 'CC', 'clang -target arm64-apple-macos12' if platform.name =~ /osx-12/
    elsif platform.architecture == 'arm64' && platform.os_version.to_i >= 13
      pkg.environment 'CC', 'clang'
    end
  end

  if platform.name =~ /sles-15|el-8|debian-10/ || platform.is_fedora?
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment "LDFLAGS", settings[:ldflags]
  end

  # fix libtool linking on big sur
  if platform.is_macos?
    if platform.os_version.to_i >= 13 && platform.architecture == 'arm64'
      pkg.configure { ["/opt/homebrew/bin/autoreconf --force --install"] }
    else
      pkg.configure { ["/usr/local/bin/autoreconf --force --install"] }
    end
  end


  pkg.configure do
    ["./configure #{extra_config_flags} --prefix=#{settings[:prefix]} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end
