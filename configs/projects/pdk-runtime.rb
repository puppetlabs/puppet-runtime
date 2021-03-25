project 'pdk-runtime' do |proj|
  # Used in component configurations to conditionally include dependencies
  proj.setting(:runtime_project, "pdk")
  proj.setting(:openssl_version, '1.1.1')
  platform = proj.get_platform

  proj.version_from_git
  proj.generate_archives true
  proj.generate_packages false

  proj.description "The PDK runtime contains third-party components needed for the puppet developer kit"
  proj.license "See components"
  proj.vendor "Puppet, Inc.  <info@puppet.com>"
  proj.homepage "https://puppet.com"

  if platform.is_macos?
    proj.identifier "com.puppetlabs"
  end

  # These flags are applied in addition to the defaults in configs/component/openssl.rb.
  proj.setting(:openssl_extra_configure_flags, [
    'enable-cms',
    'enable-seed',
    'no-gost',
    'no-rc5',
    'no-srp',
  ])

  proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
  proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

  if platform.is_windows?
    proj.setting(:base_dir, "ProgramFiles64Folder")
    proj.setting(:company_id, "PuppetLabs")
    proj.setting(:product_id, "DevelopmentKit")
    proj.setting(:install_root, File.join("C:", proj.base_dir, proj.company_id, proj.product_id))
    proj.setting(:prefix, proj.install_root)
    proj.setting(:windows_tools, File.join(proj.install_root, "private/tools/bin"))
  else
    proj.setting(:install_root, "/opt/puppetlabs")
    proj.setting(:prefix, File.join(proj.install_root, "pdk"))
    proj.setting(:link_bindir, File.join(proj.prefix, "bin"))
  end

  proj.setting(:libdir, File.join(proj.prefix, "lib"))
  proj.setting(:datadir, File.join(proj.prefix, "share"))
  proj.setting(:includedir, File.join(proj.prefix, "include"))
  proj.setting(:bindir, File.join(proj.prefix, "bin"))

  proj.setting(:ruby_version, "2.4.10")
  proj.setting(:ruby_api, "2.4.0")

  # this is the latest puppet that will be installed into the default ruby version above
  # newer versions of puppet will be installed into the Ruby 2.5.6 runtime
  proj.setting(:latest_puppet, "5.5.21")

  proj.setting(:privatedir, File.join(proj.prefix, "private"))
  proj.setting(:ruby_dir, File.join(proj.privatedir, "ruby", proj.ruby_version))
  proj.setting(:ruby_bindir, File.join(proj.ruby_dir, "bin"))
  proj.setting(:gem_home, File.join(proj.ruby_dir, "lib", "ruby", "gems", proj.ruby_api))

  if platform.is_windows?
    proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby.exe"))
    proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem.bat"))
    proj.setting(:host_bundle, File.join(proj.ruby_bindir, "bundle.bat"))
  else
    proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby"))
    proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem"))
    proj.setting(:host_bundle, File.join(proj.ruby_bindir, "bundle"))
  end

  gem_install = "#{proj.host_gem} install --no-document --local "
  gem_install += "--bindir #{proj.ruby_bindir} " if platform.is_windows? # Add --bindir option for Windows...
  proj.setting(:gem_install, gem_install)

  # TODO: build this with a helper method?
  additional_rubies = {
    "2.5.8" => {
      ruby_version: "2.5.8",
      ruby_api: "2.5.0",
      ruby_dir: File.join(proj.privatedir, "ruby", "2.5.8"),
      latest_puppet: "6.21.1", # TODO: make this a semver range
    },
    "2.7.2" => {
      ruby_version: "2.7.2",
      ruby_api: "2.7.0",
      ruby_dir: File.join(proj.privatedir, "ruby", "2.7.2"),
    }
  }

  additional_rubies.each do |rubyver, local_settings|
    local_settings[:ruby_bindir] = File.join(local_settings[:ruby_dir], "bin")
    local_settings[:gem_home] = File.join(local_settings[:ruby_dir], "lib", "ruby", "gems", local_settings[:ruby_api])

    if platform.is_windows?
      local_settings[:host_ruby] = File.join(local_settings[:ruby_bindir], "ruby.exe")
      local_settings[:host_gem] = File.join(local_settings[:ruby_bindir], "gem.bat")
      local_settings[:host_bundle] = File.join(local_settings[:ruby_bindir], "bundle.bat")
    else
      local_settings[:host_ruby] = File.join(local_settings[:ruby_bindir], "ruby")
      local_settings[:host_gem] = File.join(local_settings[:ruby_bindir], "gem")
      local_settings[:host_bundle] = File.join(local_settings[:ruby_bindir], "bundle")
    end

    local_gem_install = "#{local_settings[:host_gem]} install --no-document --local "
    local_gem_install << "--bindir #{local_settings[:ruby_bindir]} " if platform.is_windows? # Add --bindir option for Windows...

    local_settings[:gem_install] = local_gem_install
  end

  proj.setting(:additional_rubies, additional_rubies)

  if platform.is_windows?
    # FIXME: may need else to set these to nil for non-windows?
    # For windows, we need to ensure we are building for mingw not cygwin
    proj.setting(:platform_triple, platform.platform_triple)
    proj.setting(:host, "--host #{platform.platform_triple}")
  end

  # Define default CFLAGS and LDFLAGS for most platforms, and then
  # tweak or adjust them as needed.
  proj.setting(:cppflags, "-I#{proj.includedir} -I/opt/pl-build-tools/include")
  proj.setting(:cflags, "#{proj.cppflags}")
  proj.setting(:ldflags, "-L#{proj.libdir} -L/opt/pl-build-tools/lib -Wl,-rpath=#{proj.libdir}")

  if platform.is_windows?
    proj.setting(:gcc_root, "C:/tools/mingw64")
    proj.setting(:gcc_bindir, "#{proj.gcc_root}/bin")
    proj.setting(:tools_root, "C:/tools/pl-build-tools")
    proj.setting(:cygwin, "nodosfilewarning winsymlinks:native")

    proj.setting(:cppflags, "-I#{proj.tools_root}/include -I#{proj.gcc_root}/include -I#{proj.includedir}")
    proj.setting(:cflags, "#{proj.cppflags}")
    proj.setting(:ldflags, "-L#{proj.tools_root}/lib -L#{proj.gcc_root}/lib -L#{proj.libdir}")
  elsif platform.is_macos?
    proj.setting(:cppflags, "-I#{proj.includedir}")

    # Since we are cross-compiling for later use, we can only optimize for
    # the oldest supported platform and even up to macOS 10.13 there are
    # a few Core 2 hardware platforms supported. (4 May 2018)
    proj.setting(:cflags, "-march=core2 -msse4 #{proj.cppflags}")

    # OS X doesn't use RPATH for linking. We shouldn't
    # define it or try to force it in the linker, because this might
    # break gcc or clang if they try to use the RPATH values we forced.
    proj.setting(:ldflags, "-L#{proj.libdir} ")
  end

  # We want PDK's vendored Git binary to use system-wide gitconfig.
  proj.setting(:git_sysconfdir, "/etc")

  # What to build?
  # --------------

  # Common deps
  proj.component "openssl-#{proj.openssl_version}"
  proj.component "curl"

  # Git and deps
  proj.component "git"

  # Ruby and deps
  proj.component "runtime-pdk"
  proj.component "puppet-ca-bundle"

  proj.component "augeas" unless platform.is_windows?
  proj.component "libxml2" unless platform.is_windows?
  proj.component "libxslt" unless platform.is_windows?

  proj.component "ruby-#{proj.ruby_version}"

  proj.component "ruby-augeas" unless platform.is_windows?

  # We only build ruby-selinux for EL 5-7
  if platform.is_el? || platform.is_fedora?
    proj.component "ruby-selinux"
  end

  proj.component "ruby-stomp"

  # PDK Rubygems
  proj.component "rubygem-ffi"
  proj.component "rubygem-locale"
  proj.component "rubygem-text"
  proj.component "rubygem-gettext"
  proj.component "rubygem-fast_gettext"
  proj.component "rubygem-gettext-setup"
  proj.component "rubygem-minitar"

  # Additional Rubies
  if proj.respond_to?(:additional_rubies)
    proj.additional_rubies.keys.each do |rubyver|
      proj.component "ruby-#{rubyver}"

      ruby_minor = rubyver.split('.')[0,2].join('.')

      proj.component "ruby-#{ruby_minor}-augeas" unless platform.is_windows?
      proj.component "ruby-#{ruby_minor}-selinux" if platform.is_el? || platform.is_fedora?
      proj.component "ruby-#{ruby_minor}-stomp"
    end
  end

  # Platform specific deps
  proj.component "ansicon" if platform.is_windows?

  # What to include in package?
  proj.directory proj.install_root
  proj.directory proj.prefix
  proj.directory proj.link_bindir unless platform.is_windows?

  # Export the settings for the current project and platform as yaml during builds
  proj.publish_yaml_settings

  proj.timeout 7200 if platform.is_windows?

  # Here we rewrite public http urls to use our internal source host instead.
  # Something like https://www.openssl.org/source/openssl-1.0.0r.tar.gz gets
  # rewritten as
  # https://artifactory.delivery.puppetlabs.net/artifactory/generic/buildsources/openssl-1.0.0r.tar.gz
  proj.register_rewrite_rule 'http', proj.buildsources_url
end
