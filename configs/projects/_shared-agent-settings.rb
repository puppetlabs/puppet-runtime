# This "project" is designed to be shared by all puppet-agent projects
# See configs/projects/agent-runtime-<branchname>.rb
unless defined?(proj)
  warn('These are base settings shared by all puppet-agent projects; They cannot be built as a standalone project.')
  warn('Please choose one of the other puppet-agent projects instead.')
  exit 1
end

# Export the settings for the current project and platform as yaml during builds
proj.publish_yaml_settings

# Use sparingly in component configurations to conditionally include
# dependencies that should not be in other projects that use puppet-runtime
proj.setting(:runtime_project, 'agent')

########
# Common build settings for all versions of puppet-agent
########

proj.generate_archives true
proj.generate_packages false

proj.description 'The puppet agent runtime contains third-party components needed for the puppet agent'
proj.license 'See components'
proj.vendor 'Puppet, Inc.  <info@puppet.com>'
proj.homepage 'https://puppet.com'
proj.version_from_git

proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

if platform.is_windows?
  proj.setting(:company_id, "PuppetLabs")
  proj.setting(:product_id, "Puppet")
  if platform.architecture == "x64"
    proj.setting(:base_dir, "ProgramFiles64Folder")
  else
    proj.setting(:base_dir, "ProgramFilesFolder")
  end
  # We build for windows not in the final destination, but in the paths that correspond
  # to the directory ids expected by WIX. This will allow for a portable installation (ideally).
  proj.setting(:install_root, File.join("C:", proj.base_dir, proj.company_id, proj.product_id))
  proj.setting(:sysconfdir, File.join("C:", "CommonAppDataFolder", proj.company_id))
  proj.setting(:tmpfilesdir, "C:/Windows/Temp")
else
  proj.setting(:install_root, "/opt/puppetlabs")
  if platform.is_macos?
    proj.setting(:sysconfdir, "/private/etc/puppetlabs")
  else
    proj.setting(:sysconfdir, "/etc/puppetlabs")
  end
  proj.setting(:logdir, "/var/log/puppetlabs")
  if platform.is_linux? && platform.name !~ /sles-11|el-6/
    proj.setting(:piddir, "/run/puppetlabs")
  else
    proj.setting(:piddir, "/var/run/puppetlabs")
  end
  proj.setting(:tmpfilesdir, "/usr/lib/tmpfiles.d")
end

proj.setting(:miscdir, File.join(proj.install_root, "misc"))
proj.setting(:prefix, File.join(proj.install_root, "puppet"))
proj.setting(:bindir, File.join(proj.prefix, "bin"))
proj.setting(:libdir, File.join(proj.prefix, "lib"))
proj.setting(:link_bindir, File.join(proj.install_root, "bin"))
proj.setting(:includedir, File.join(proj.prefix, "include"))
proj.setting(:datadir, File.join(proj.prefix, "share"))
proj.setting(:mandir, File.join(proj.datadir, "man"))

if platform.is_windows?
  proj.setting(:windows_tools, proj.bindir)
end

proj.setting(:ruby_dir, proj.prefix)
proj.setting(:ruby_bindir, proj.bindir)

raise "Couldn't find a :ruby_version setting in the project file" unless proj.ruby_version
ruby_base_version = proj.ruby_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2.0')
ruby_version_y = proj.ruby_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2')
ruby_version_x = proj.ruby_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1')

proj.setting(:gem_home, File.join(proj.libdir, 'ruby', 'gems', ruby_base_version))
proj.setting(:ruby_vendordir, File.join(proj.libdir, "ruby", "vendor_ruby"))

# Cross-compiled Linux platforms
platform_triple = "ppc64le-redhat-linux" if platform.architecture == "ppc64le"
platform_triple = "powerpc64le-suse-linux" if platform.architecture == "ppc64le" && platform.name =~ /^sles-/
platform_triple = "powerpc64le-linux-gnu" if platform.architecture == "ppc64el"
platform_triple = "arm-linux-gnueabihf" if platform.architecture == "armhf"
platform_triple = "aarch64-apple-darwin" if platform.is_cross_compiled? && platform.is_macos?

# Ruby's build process needs a functional "baseruby". When native compiling,
# ruby will build "miniruby" and use that as "baseruby". When cross compiling,
# we need a "host" ruby from somewhere else.
#
# Our build process also needs a "host" ruby to install rubygem-* components.
if platform.is_windows?
  proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby.exe"))
  proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem.bat"))
elsif platform.is_cross_compiled? && (platform.is_linux? || platform.is_solaris?)
  if platform.name =~ /solaris-10-sparc/
    proj.setting(:host_ruby, "/opt/csw/bin/ruby")
    proj.setting(:host_gem, "/opt/csw/bin/gem2.0")
  else
    proj.setting(:host_ruby, "/opt/pl-build-tools/bin/ruby")
    proj.setting(:host_gem, "/opt/pl-build-tools/bin/gem")
  end
elsif platform.is_cross_compiled? && platform.is_macos?
  proj.setting(:host_ruby, "/usr/local/opt/ruby@#{ruby_version_y}/bin/ruby")
  proj.setting(:host_gem, "/usr/local/opt/ruby@#{ruby_version_y}/bin/gem")
else
  proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby"))
  proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem"))
end

if platform.is_cross_compiled_linux?
  host = "--host #{platform_triple}"
elsif platform.is_cross_compiled? && platform.is_macos?
  host = "--host aarch64-apple-darwin --build x86_64-apple-darwin --target aarch64-apple-darwin"
elsif platform.is_solaris?
  if platform.architecture == 'i386'
    platform_triple = "#{platform.architecture}-pc-solaris2.#{platform.os_version}"
  else
    platform_triple = "#{platform.architecture}-sun-solaris2.#{platform.os_version}"
    host = "--host #{platform_triple}"
  end
elsif platform.is_windows?
  # For windows, we need to ensure we are building for mingw not cygwin
  platform_triple = platform.platform_triple
  host = "--host #{platform_triple}"
end

proj.setting(:gem_install, "#{proj.host_gem} install --no-rdoc --no-ri --local ")

# For AIX, we use the triple to install a better rbconfig
if platform.is_aix?
  platform_triple = "powerpc-ibm-aix#{platform.os_version}.0.0"
end

proj.setting(:platform_triple, platform_triple)
proj.setting(:host, host)

# Load default compiler settings
instance_eval File.read('configs/projects/_shared-compiler-settings.rb')

if ruby_version_x == "3"
  proj.setting(:openssl_version, '3.0')
elsif platform.name =~ /^redhatfips-/
  proj.setting(:openssl_version, '1.1.1-fips')
elsif platform.name =~ /^windowsfips-2012r2/
  proj.setting(:openssl_version, '1.0.2')
else
  proj.setting(:openssl_version, '1.1.1')
end

if platform.is_windows?
  arch = platform.architecture == "x64" ? "64" : "32"
  proj.setting(:gcc_root, "C:/tools/mingw#{arch}")
  proj.setting(:vs_version, '2017')
  # The msbuild command needs to be surrounded in quotes and shelled
  # out to cmd.exe because otherwise cygwin will treat the && in bash and
  # fail. Even though the invocation of msbuild is in quotes, parameters
  # sent to it don't need extra quotes or escaping.
  proj.setting(:msbuild, "cmd.exe /C \"C:/tools/vsdevcmd.bat && msbuild\"")
  proj.setting(:gcc_bindir, "#{proj.gcc_root}/bin")
  proj.setting(:tools_root, "C:/tools/pl-build-tools")
  proj.setting(:cppflags, "-I#{proj.tools_root}/include -I#{proj.gcc_root}/include -I#{proj.includedir}")
  proj.setting(:cflags, "#{proj.cppflags}")

  ldflags = "-L#{proj.tools_root}/lib -L#{proj.gcc_root}/lib -L#{proj.libdir} -Wl,--nxcompat"
  if platform.name !~ /windowsfips-2012r2/ || name != 'agent-runtime-7.x'
    ldflags += ' -Wl,--dynamicbase'
  end
  proj.setting(:ldflags, ldflags)

  proj.setting(:cygwin, "nodosfilewarning winsymlinks:native")
else
  proj.setting(:tools_root, "/opt/pl-build-tools")
end

if platform.is_macos?
  # For OS X, we should optimize for an older architecture than Apple
  # currently ships for; there's a lot of older xeon chips based on
  # that architecture still in use throughout the Mac ecosystem.
  # Additionally, OS X doesn't use RPATH for linking. We shouldn't
  # define it or try to force it in the linker, because this might
  # break gcc or clang if they try to use the RPATH values we forced.
  proj.setting(:cppflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir}")
  if platform.architecture == 'arm64'
    proj.setting(:cflags, "#{proj.cppflags}")
  else
    proj.setting(:cflags, "-march=core2 -msse4 #{proj.cppflags}")
  end
end

if platform.is_aix?
  if platform.name == 'aix-7.1-ppc'
    proj.setting(:ldflags, "-Wl,-brtl -L#{proj.libdir} -L/opt/pl-build-tools/lib")
  else
    proj.setting(:ldflags, "-Wl,-brtl -L#{proj.libdir}")
  end
end

if platform.is_solaris?
  proj.identifier 'puppetlabs.com'
elsif platform.is_macos?
  proj.identifier 'com.puppetlabs'
end

proj.timeout 7200 if platform.is_windows?

# These are the boost libraries we care about for facter and friends
proj.setting(:boost_libs, ["chrono", "date_time", "filesystem", "locale", "log", "program_options",
                           "random", "regex", "system", "thread"])
proj.setting(:boost_link_option, "link=shared")

# Most branches of puppet-agent use these openssl flags in addition to the defaults in configs/components/openssl.rb -
# Individual projects can override these if necessary.
proj.setting(:openssl_extra_configure_flags, [
  'no-dtls',
  'no-dtls1',
  'no-idea',
  'no-seed',
  # 'no-ssl2-method',
  'no-weak-ssl-ciphers',
  '-DOPENSSL_NO_HEARTBEATS',
]) unless proj.settings[:openssl_extra_configure_flags]

# Commmon platform-specific settings for all agent branches:
platform = proj.get_platform

# What to include in package?
proj.directory proj.install_root
proj.directory proj.prefix
proj.directory proj.sysconfdir
proj.directory proj.link_bindir
proj.directory proj.bindir if platform.is_windows? || platform.is_macos?
