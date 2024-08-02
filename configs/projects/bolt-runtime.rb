project 'bolt-runtime' do |proj|
  # Used in component configurations to conditionally include dependencies
  proj.setting(:runtime_project, 'bolt')
  proj.setting(:ruby_version, '2.7.8')
  proj.setting(:openssl_version, '1.1.1')
  proj.setting(:rubygem_net_ssh_version, '6.1.0')
  proj.setting(:augeas_version, '1.14.1')
  # TODO: Can runtime projects use these updated versions?
  proj.setting(:rubygem_deep_merge_version, '1.2.2')
  proj.setting(:rubygem_puppet_version, '7.32.1')

  platform = proj.get_platform

  proj.version_from_git
  proj.generate_archives true
  proj.generate_packages false

  proj.description "The Bolt runtime contains third-party components needed for Bolt standalone packaging"
  proj.license "See components"
  proj.vendor "Puppet, Inc.  <info@puppet.com>"
  proj.homepage "https://puppet.com"
  proj.identifier "com.puppetlabs"

  if platform.is_windows?
    proj.setting(:company_id, "PuppetLabs")
    proj.setting(:product_id, "Bolt")
    if platform.architecture == "x64"
      proj.setting(:base_dir, "ProgramFiles64Folder")
    else
      proj.setting(:base_dir, "ProgramFilesFolder")
    end
    # We build for windows not in the final destination, but in the paths that correspond
    # to the directory ids expected by WIX. This will allow for a portable installation (ideally).
    proj.setting(:prefix, File.join("C:", proj.base_dir, proj.company_id, proj.product_id))
  else
    proj.setting(:prefix, "/opt/puppetlabs/bolt")
  end

  proj.setting(:ruby_dir, proj.prefix)
  proj.setting(:bindir, File.join(proj.prefix, 'bin'))
  proj.setting(:ruby_bindir, proj.bindir)
  proj.setting(:libdir, File.join(proj.prefix, 'lib'))
  proj.setting(:includedir, File.join(proj.prefix, "include"))
  proj.setting(:datadir, File.join(proj.prefix, "share"))
  proj.setting(:mandir, File.join(proj.datadir, "man"))

  if platform.is_windows?
    proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby.exe"))
    proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem.bat"))

    # For windows, we need to ensure we are building for mingw not cygwin
    platform_triple = platform.platform_triple
    host = "--host #{platform_triple}"
  else
    proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby"))
    proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem"))
  end

  ruby_base_version = proj.ruby_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2.0')
  proj.setting(:gem_home, File.join(proj.libdir, 'ruby', 'gems', ruby_base_version))
  proj.setting(:gem_install, "#{proj.host_gem} install --no-document --local --bindir=#{proj.ruby_bindir}")

  proj.setting(:platform_triple, platform_triple)
  proj.setting(:host, host)

  proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
  proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

  # Define default CFLAGS and LDFLAGS for most platforms, and then
  # tweak or adjust them as needed.
  proj.setting(:cppflags, "-I#{proj.includedir} -I/opt/pl-build-tools/include")
  proj.setting(:cflags, "#{proj.cppflags}")
  proj.setting(:ldflags, "-L#{proj.libdir} -L/opt/pl-build-tools/lib -Wl,-rpath=#{proj.libdir}")

  # Platform specific overrides or settings, which may override the defaults
  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    proj.setting(:gcc_root, "C:/tools/mingw#{arch}")
    proj.setting(:gcc_bindir, "#{proj.gcc_root}/bin")
    proj.setting(:tools_root, "C:/tools/pl-build-tools")
    proj.setting(:cppflags, "-I#{settings[:includedir]}/ruby-2.7.0 -I#{proj.tools_root}/include -I#{proj.gcc_root}/include -I#{proj.includedir}")
    proj.setting(:cflags, "#{proj.cppflags}")
    proj.setting(:ldflags, "-L#{proj.tools_root}/lib -L#{proj.gcc_root}/lib -L#{proj.libdir} -Wl,--nxcompat -Wl,--dynamicbase")
    proj.setting(:cygwin, "nodosfilewarning winsymlinks:native")
  end

  if platform.is_macos?
    proj.setting(:cppflags, "-I#{proj.includedir}")
    proj.setting(:cflags, proj.cppflags.to_s)

    # For OS X, we should optimize for an older x86 architecture than Apple
    # currently ships for; there's a lot of older xeon chips based on
    # that architecture still in use throughout the Mac ecosystem.
    # Additionally, OS X doesn't use RPATH for linking. We shouldn't
    # define it or try to force it in the linker, because this might
    # break gcc or clang if they try to use the RPATH values we forced.
    proj.setting(:cflags, "-march=core2 -msse4 #{proj.cflags}") unless platform.architecture == 'arm64'

    proj.setting(:ldflags, "-L#{proj.libdir} ")
  end

  # These flags are applied in addition to the defaults in configs/component/openssl.rb.
  proj.setting(:openssl_extra_configure_flags, [
    'no-dtls',
    'no-dtls1',
    'no-idea',
    'no-seed',
    'no-weak-ssl-ciphers',
    '-DOPENSSL_NO_HEARTBEATS',
  ])

  # What to build?
  # --------------

  # Ruby and deps
  proj.component "openssl-#{proj.openssl_version}"
  proj.component "runtime-bolt"
  proj.component "puppet-ca-bundle"
  proj.component "ruby-#{proj.ruby_version}"

  proj.component 'rubygem-bcrypt_pbkdf'
  proj.component 'rubygem-ed25519'

  # Puppet dependencies
  proj.component 'rubygem-hocon'
  proj.component 'rubygem-deep_merge'
  proj.component 'rubygem-text'
  proj.component 'rubygem-locale'
  proj.component 'rubygem-gettext'
  proj.component 'rubygem-prime'
  proj.component 'rubygem-fast_gettext'
  proj.component 'rubygem-scanf'
  proj.component 'rubygem-semantic_puppet'

  # R10k dependencies
  proj.component 'rubygem-gettext-setup'

  # hiera-eyaml and its dependencies
  proj.component 'rubygem-highline'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-hiera-eyaml'

  # faraday and its dependencies
  proj.component 'rubygem-faraday'
  proj.component 'rubygem-faraday-em_http'
  proj.component 'rubygem-faraday-em_synchrony'
  proj.component 'rubygem-faraday-excon'
  proj.component 'rubygem-faraday-httpclient'
  proj.component 'rubygem-faraday-multipart'
  proj.component 'rubygem-faraday-net_http'
  proj.component 'rubygem-faraday-net_http_persistent'
  proj.component 'rubygem-faraday-patron'
  proj.component 'rubygem-faraday-rack'
  proj.component 'rubygem-faraday-retry'
  proj.component 'rubygem-faraday_middleware'
  proj.component 'rubygem-ruby2_keywords'

  # Core dependencies
  proj.component 'rubygem-addressable'
  proj.component 'rubygem-aws-eventstream'
  proj.component 'rubygem-aws-partitions'
  proj.component 'rubygem-aws-sdk-core'
  proj.component 'rubygem-aws-sdk-ec2'
  proj.component 'rubygem-aws-sigv4'
  proj.component 'rubygem-bindata'
  proj.component 'rubygem-builder'
  proj.component 'rubygem-CFPropertyList'
  proj.component 'rubygem-colored2'
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-connection_pool'
  proj.component 'rubygem-cri'
  proj.component 'rubygem-erubi'
  proj.component 'rubygem-facter'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-gssapi'
  proj.component 'rubygem-gyoku'
  proj.component 'rubygem-hiera'
  proj.component 'rubygem-httpclient'
  proj.component 'rubygem-jmespath'
  proj.component 'rubygem-jwt'
  proj.component 'rubygem-little-plugger'
  proj.component 'rubygem-log4r'
  proj.component 'rubygem-logging'
  proj.component 'rubygem-minitar'
  proj.component 'rubygem-molinillo'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-multipart-post'
  proj.component 'rubygem-net-http-persistent'
  proj.component 'rubygem-net-scp'
  proj.component 'rubygem-net-ssh'
  proj.component 'rubygem-net-ssh-krb'
  proj.component 'rubygem-nori'
  proj.component 'rubygem-orchestrator_client'
  proj.component 'rubygem-paint'
  proj.component 'rubygem-public_suffix'
  proj.component 'rubygem-puppet'
  proj.component 'rubygem-puppet_forge'
  proj.component 'rubygem-puppet-resource_api'
  proj.component 'rubygem-puppet-strings'
  proj.component 'rubygem-puppetfile-resolver'
  proj.component 'rubygem-r10k'
  proj.component 'rubygem-rgen'
  proj.component 'rubygem-rubyntlm'
  proj.component 'rubygem-ruby_smb'
  proj.component 'rubygem-rubyzip'
  proj.component 'rubygem-sys-filesystem'
  proj.component 'rubygem-terminal-table'
  proj.component 'rubygem-thor'
  proj.component 'rubygem-unicode-display_width'
  proj.component 'rubygem-webrick'
  proj.component 'rubygem-yard'

  # Core Windows dependencies
  proj.component 'rubygem-windows_error'
  proj.component 'rubygem-winrm'
  proj.component 'rubygem-winrm-fs'

  # Components from puppet-runtime included to support apply on localhost
  # We only build ruby-selinux for EL, Fedora, Debian and Ubuntu (amd64/i386)
  if platform.is_el? || platform.is_fedora? || platform.is_debian? || (platform.is_ubuntu? && platform.architecture !~ /ppc64el$/)
    proj.component 'ruby-selinux'
  end

  # Non-windows specific components
  unless platform.is_windows?
    # C Augeas + deps
    proj.component 'readline' if platform.is_macos?
    proj.component 'augeas'
    proj.component 'libxml2'
    proj.component 'libxslt'
    # Ruby Augeas and shadow
    proj.component 'ruby-augeas'
    proj.component 'ruby-shadow'
  end

  # What to include in package?
  proj.directory proj.prefix

  # Export the settings for the current project and platform as yaml during builds
  proj.publish_yaml_settings

  proj.timeout 7200 if platform.is_windows?
end
