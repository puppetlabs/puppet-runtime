# This project is designed for reuse by branch-specific client-tools-runtime configs;
# See configs/projects/client-tools-runtime-<branchname>.rb
unless defined?(proj)
  warn('This is the base project for the client-tools runtime.')
  warn('Please choose one of the other client-tools projects instead.')
  exit 1
end

proj.setting(:runtime_project, 'client-tools')

proj.generate_archives true
proj.generate_packages false

proj.description "The client-tools runtime contains third-party components needed for client-tools"
proj.license "See components"
proj.vendor "Puppet, Inc.  <info@puppet.com>"
proj.homepage "https://puppet.com"
proj.identifier "com.puppetlabs"
proj.version_from_git

platform = proj.get_platform

if proj.settings[:openssl_version]
  # already defined in the project
elsif platform.name =~ /^redhatfips-*/
  proj.setting(:openssl_version, '1.1.1-fips')
else
  proj.setting(:openssl_version, '1.1.1')
end

proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

if platform.is_windows?
  # Windows Installer settings.
  proj.setting(:company_id, "PuppetLabs")
  proj.setting(:product_id, "Client")
  if platform.architecture == "x64"
    proj.setting(:base_dir, "ProgramFiles64Folder")
  else
    proj.setting(:base_dir, "ProgramFilesFolder")
  end

  proj.setting(:prefix, File.join("C:", proj.base_dir, proj.company_id, proj.product_id, 'tools'))
else
  proj.setting(:prefix, "/opt/puppetlabs/client-tools")
end

proj.setting(:bindir, File.join(proj.prefix, "bin"))
proj.setting(:libdir, File.join(proj.prefix, "lib"))
proj.setting(:includedir, File.join(proj.prefix, "include"))
proj.setting(:datadir, File.join(proj.prefix, "share"))
proj.setting(:mandir, File.join(proj.datadir, "man"))

proj.setting(:host, "--host #{platform.platform_triple}") if platform.is_windows?
proj.setting(:platform_triple, platform.platform_triple)

# These are the boost libraries we care about for leatherman
proj.setting(:boost_libs, ["chrono", "date_time", "filesystem", "locale", "log", "program_options",
                           "regex", "system", "thread"])
proj.setting(:boost_link_option, "")
proj.setting(:boost_bootstrap_flags, "--without-icu")
proj.setting(:boost_b2_flags, "--disable-icu")
proj.setting(:boost_b2_install_flags, "boost.locale.icu=off")

if platform.is_macos?
  # For macOS, we should optimize for an older architecture than Apple
  # currently ships for; there's a lot of older xeon chips based on
  # that architecture still in use throughout the Mac ecosystem.
  # Additionally, macOS doesn't use RPATH for linking. We shouldn't
  # define it or try to force it in the linker, because this might
  # break gcc or clang if they try to use the RPATH values we forced.
  proj.setting(:cppflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} ")
  if platform.is_cross_compiled?
    # The core2 architecture is not available on M1 Macs
    proj.setting(:cflags, "#{proj.cppflags}")
    proj.setting(:host, "--host aarch64-apple-darwin --build x86_64-apple-darwin --target aarch64-apple-darwin")
  elsif platform.architecture == 'arm64'
    proj.setting(:cflags, "#{proj.cppflags}")
  else
    proj.setting(:cflags, "-march=core2 -msse4 #{proj.cppflags}")
  end
elsif platform.is_windows?
  arch = platform.architecture == "x64" ? "64" : "32"
  proj.setting(:gcc_root, "C:/tools/mingw#{arch}")
  proj.setting(:gcc_bindir, "#{proj.gcc_root}/bin")
  proj.setting(:tools_root, "C:/tools/pl-build-tools")
  proj.setting(:chocolatey_bin, 'C:/ProgramData/chocolatey/bin')
  proj.setting(:cppflags, "-I#{proj.tools_root}/include -I#{proj.gcc_root}/include -I#{proj.includedir}")
  proj.setting(:cflags, "#{proj.cppflags}")
  proj.setting(:ldflags, "-L#{proj.tools_root}/lib -L#{proj.gcc_root}/lib -L#{proj.libdir} -Wl,--nxcompat -Wl,--dynamicbase")
  proj.setting(:cygwin, "nodosfilewarning winsymlinks:native")
else
  proj.setting(:tools_root, "/opt/pl-build-tools")
  proj.setting(:cppflags, "-I#{proj.includedir} -I/opt/pl-build-tools/include")
  proj.setting(:cflags, "#{proj.cppflags}")
  proj.setting(:ldflags, "-L#{proj.libdir} -L/opt/pl-build-tools/lib -Wl,-rpath=#{proj.libdir}")
end

# What to build?
# --------------

# Common deps
proj.component "runtime-client-tools"
proj.component "openssl-#{proj.openssl_version}"
proj.component "curl"
proj.component "puppet-ca-bundle"
proj.component "libicu"
proj.component "boost"

# What to include in package?
proj.directory proj.prefix

# Export the settings for the current project and platform as yaml during builds
proj.publish_yaml_settings

proj.timeout 7200 if platform.is_windows?
