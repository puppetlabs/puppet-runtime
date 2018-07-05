# This file is a basis for multiple ruby versions.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y.z.rb configs.

# Condensed version, e.g. '2.4.3' -> '243'
ruby_version_condensed = pkg.get_version.tr('.', '')
# Y version, e.g. '2.4.3' -> '2.4'
ruby_version_y = pkg.get_version.gsub(/(\d)\.(\d)\.(\d)/, '\1.\2')

pkg.mirror "#{settings[:buildsources_url]}/ruby-#{pkg.get_version}.tar.gz"
pkg.url "https://cache.ruby-lang.org/pub/ruby/#{ruby_version_y}/ruby-#{pkg.get_version}.tar.gz"


# These may have been overridden in the including file,
# if not then default them back to original values.
ruby_dir ||= settings[:ruby_dir]
ruby_bindir ||= settings[:ruby_bindir]

#########
# SOURCES
#########

if platform.is_windows?
  pkg.add_source "file://resources/files/ruby_#{ruby_version_condensed}/windows_ruby_gem_wrapper.bat"
end

# Cross-compiles require a hand-built rbconfig from the target system as does Solaris, AIX and Windies
if platform.is_cross_compiled_linux? || platform.is_solaris? || platform.is_aix? || platform.is_windows?
  pkg.add_source "file://resources/files/ruby_#{ruby_version_condensed}/rbconfig/rbconfig-#{ruby_version_condensed}-#{settings[:platform_triple]}.rb"
end

#############
# ENVIRONMENT
#############

if platform.is_aix?
#  pkg.environment 'CC', '/opt/pl-build-tools/bin/gcc'
  pkg.environment 'LDFLAGS', "#{settings[:ldflags]} -Wl,-bmaxdata:0x80000000"
elsif platform.is_solaris?
  pkg.environment 'PATH', "#{settings[:bindir]}:/usr/ccs/bin:/usr/sfw/bin:$$PATH:/opt/csw/bin"
  pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"
  pkg.environment 'LDFLAGS', "-Wl,-rpath=#{settings[:libdir]}"
elsif platform.is_cross_compiled_linux? || platform.is_solaris?
  pkg.environment 'PATH', "#{settings[:bindir]}:$$PATH"
  pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"
  pkg.environment 'LDFLAGS', "-Wl,-rpath=#{settings[:libdir]}"
elsif platform.is_windows?
  pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:tools_root]}/bin):$(shell cygpath -u #{settings[:tools_root]}/include):$(shell cygpath -u #{settings[:bindir]}):$(shell cygpath -u #{ruby_bindir}):$(shell cygpath -u #{settings[:includedir]}):$(PATH)"
  pkg.environment 'CYGWIN', settings[:cygwin]
  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'optflags', settings[:cflags] + ' -O3'
elsif platform.is_macos?
  pkg.environment 'optflags', settings[:cflags]
end

####################
# BUILD REQUIREMENTS
####################

if settings[:system_openssl]
  pkg.build_requires 'openssl-devel'
else
  pkg.build_requires 'openssl'
end

if platform.is_aix?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  pkg.build_requires 'libedit'
elsif platform.is_solaris?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  pkg.build_requires 'libedit'
  if platform.architecture == 'sparc'
    if platform.os_version == '11'
      pkg.build_requires 'pl-ruby'
    end
  end
elsif platform.is_cross_compiled_linux?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  pkg.build_requires 'pl-ruby'
elsif platform.is_windows?
  pkg.build_requires "pl-gdbm-#{platform.architecture}"
  pkg.build_requires "pl-iconv-#{platform.architecture}"
  pkg.build_requires "pl-libffi-#{platform.architecture}"
  pkg.build_requires "pl-pdcurses-#{platform.architecture}"
end

if platform.is_deb?
  pkg.build_requires 'zlib1g-dev'
elsif platform.is_rpm?
  pkg.build_requires 'zlib-devel'
elsif platform.is_windows?
  pkg.build_requires "pl-zlib-#{platform.architecture}"
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

if platform.is_windows?
  # Because the autogenerated batch wrappers for ruby built from source are
  # not consistent with legacy builds, we removed the addition of the batch
  # wrappers from the build of ruby and instead we will just put them in
  # ourselves. note that we can use the same source file for all batch wrappers
  # because the batch wrappers use the wrappers file name to find the source
  # to execute (i.e. irb.bat will look to execute "irb" due to it's filename)
  # Note that this step must happen before the install step below
  pkg.install do
    ["cp ../windows_ruby_gem_wrapper.bat #{ruby_bindir}/irb.bat",
     "cp ../windows_ruby_gem_wrapper.bat #{ruby_bindir}/gem.bat",
     "cp ../windows_ruby_gem_wrapper.bat #{ruby_bindir}/rake.bat",
     "cp ../windows_ruby_gem_wrapper.bat #{ruby_bindir}/erb.bat",
     "cp ../windows_ruby_gem_wrapper.bat #{ruby_bindir}/rdoc.bat",
     "cp ../windows_ruby_gem_wrapper.bat #{ruby_bindir}/ri.bat",]
  end
end

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
  lib_type = platform.architecture == "x64" ? "seh" : "sjlj"

  pkg.install do
    [
      "cp #{settings[:bindir]}/libgcc_s_#{lib_type}-1.dll #{ruby_bindir}",
      "cp #{settings[:bindir]}/ssleay32.dll #{ruby_bindir}",
      "cp #{settings[:bindir]}/libeay32.dll #{ruby_bindir}",
    ]
  end

  pkg.directory ruby_dir
end
