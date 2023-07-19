# This file is a basis for multiple ruby versions.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y.z.rb configs.

# Condensed version, e.g. '2.4.3' -> '243'
ruby_version_condensed = pkg.get_version.tr('.', '')
# Y version, e.g. '2.4.3' -> '2.4'
ruby_version_y = pkg.get_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2')

pkg.mirror "#{settings[:buildsources_url]}/ruby-#{pkg.get_version}.tar.gz"
pkg.url "https://cache.ruby-lang.org/pub/ruby/#{ruby_version_y}/ruby-#{pkg.get_version}.tar.gz"


# These may have been overridden in the including file,
# if not then default them back to original values.
ruby_dir ||= settings[:ruby_dir]
ruby_bindir ||= settings[:ruby_bindir]


#############
# ENVIRONMENT
#############

if platform.is_aix?
  if platform.name == 'aix-7.1-ppc'
    pkg.environment "CC", "/opt/pl-build-tools/bin/gcc"
  else
    pkg.environment "CC", "/opt/freeware/bin/gcc"
  end
  pkg.environment 'LDFLAGS', "#{settings[:ldflags]} -Wl,-bmaxdata:0x80000000"
elsif platform.is_solaris?
  # See PA-5639, if we decide to go without OpenCSW GCC then we can simplify this logic
  if ruby_version_y >= '3.0'
    pkg.environment 'PATH', "#{settings[:bindir]}:/opt/csw/bin:/usr/ccs/bin:/usr/sfw/bin:$(PATH)"
    pkg.environment 'CC', '/opt/csw/bin/gcc'
    pkg.environment 'LD', '/opt/csw/bin/gld'
    pkg.environment 'AR', '/opt/csw/bin/gar'
  else
    pkg.environment 'PATH', "#{settings[:bindir]}:/usr/ccs/bin:/usr/sfw/bin:$(PATH):/opt/csw/bin"
    pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"
  end
  pkg.environment 'CXX', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
  pkg.environment 'LDFLAGS', "-Wl,-rpath=#{settings[:libdir]}"
  if platform.os_version == '10'
    # ./configure uses /bin/sh as the default shell when running config.sub on Solaris 10;
    # This doesn't work and halts the configure process. Set CONFIG_SHELL to force use of bash:
    pkg.environment 'CONFIG_SHELL', '/bin/bash'
  end
elsif platform.is_cross_compiled_linux?
  pkg.environment 'PATH', "#{settings[:bindir]}:$(PATH)"
  pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"
  pkg.environment 'CXX', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
  pkg.environment 'LDFLAGS', "-Wl,-rpath=#{settings[:libdir]}"
elsif platform.is_windows?
  pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:tools_root]}/bin):$(shell cygpath -u #{settings[:tools_root]}/include):$(shell cygpath -u #{settings[:bindir]}):$(shell cygpath -u #{ruby_bindir}):$(shell cygpath -u #{settings[:includedir]}):$(PATH)"
  pkg.environment 'CYGWIN', settings[:cygwin]
  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'optflags', settings[:cflags] + ' -O3'
elsif platform.is_macos?
  pkg.environment 'optflags', settings[:cflags]
  if platform.is_cross_compiled?
    # Pin to an older version of ruby@2.7 hosted by Puppet as Homebrew
    # moved its Ruby 2.7 formula from OpenSSL 1.1 to 3.0
    if ruby_version_y == "2.7"
      pkg.build_requires "puppetlabs/puppet/ruby@2.7"
    else
      pkg.build_requires "ruby@#{ruby_version_y}"
    end
    pkg.environment 'CC', 'clang -target arm64-apple-macos11' if platform.name =~ /osx-11/
    pkg.environment 'CC', 'clang -target arm64-apple-macos12' if platform.name =~ /osx-12/
  elsif platform.architecture == 'arm64' && platform.os_version.to_i >= 13
    pkg.environment 'CC', 'clang'
  end
end

####################
# BUILD REQUIREMENTS
####################

pkg.build_requires "openssl-#{settings[:openssl_version]}"

if platform.is_aix?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  if platform.name == 'aix-7.1-ppc'
    pkg.build_requires "libedit"
  else
    pkg.build_requires "readline"
  end
elsif platform.is_solaris?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  pkg.build_requires "libedit" if platform.name =~ /^solaris-10-sparc/
elsif platform.is_cross_compiled_linux?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
end

#######
# BUILD
#######

pkg.build do
  "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
end

#########
# INSTALL
#########

pkg.install do
  [ "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install" ]
end

if platform.is_windows? && settings[:bindir] != ruby_bindir
  # As things stand right now, ssl should build under [INSTALLDIR]\Puppet\puppet on
  # windows. However, if things need to run *outside* of the normal batch file runs
  # (puppet.bat ,mco.bat etcc) the location of openssl away from where ruby is
  # installed will cause a failure. Specifically this is meant to help services like
  # mco that require openssl but don't have access to environment.bat. Refer to
  # https://tickets.puppetlabs.com/browse/RE-7593 for details on why this causes
  # failures and why these copies fix that.
  #                   -Sean P. McDonald 07/01/2016
  if platform.architecture == "x64"
    gcc_postfix = 'seh'
    ssl_postfix = '-x64'
  else
    gcc_postfix = 'sjlj'
    ssl_postfix = ''
  end

  if Gem::Version.new(settings[:openssl_version]) >= Gem::Version.new('1.1.0')
    ssl_lib = "libssl-1_1#{ssl_postfix}.dll"
    crypto_lib = "libcrypto-1_1#{ssl_postfix}.dll"
  else
    ssl_lib = "ssleay32.dll"
    crypto_lib = "libeay32.dll"
  end

  pkg.install do
    [
      "cp #{settings[:bindir]}/libgcc_s_#{gcc_postfix}-1.dll #{ruby_bindir}",
      "cp #{settings[:bindir]}/#{ssl_lib} #{ruby_bindir}",
      "cp #{settings[:bindir]}/#{crypto_lib} #{ruby_bindir}",
    ]
  end

  pkg.directory ruby_dir
end
