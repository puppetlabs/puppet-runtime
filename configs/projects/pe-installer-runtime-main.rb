project 'pe-installer-runtime-main' do |proj|
  # Used in component configurations to conditionally include dependencies
  proj.setting(:runtime_project, 'pe-installer')
  proj.setting(:ruby_version, '2.7.7')
  proj.setting(:augeas_version, '1.11.0')
  # We need to explicitly define 1.1.1k here to avoid
  # build dep conflicts between openssl-1.1.1 needed by curl
  # and krb5-devel
  if platform.name =~ /^redhatfips-8/
    proj.setting(:openssl_version, '1.1.1k')
  else 
    proj.setting(:openssl_version, '1.1.1')
  end
  platform = proj.get_platform

  proj.version_from_git
  proj.generate_archives true
  proj.generate_packages false

  proj.description "The PE Installer runtime contains third-party components needed for PE Installer standalone packaging"
  proj.license "See components"
  proj.vendor "Puppet, Inc.  <info@puppet.com>"
  proj.homepage "https://puppet.com"
  proj.identifier "com.puppetlabs"

  proj.setting(:prefix, "/opt/puppetlabs/installer")

  proj.setting(:ruby_dir, proj.prefix)
  proj.setting(:bindir, File.join(proj.prefix, 'bin'))
  proj.setting(:ruby_bindir, proj.bindir)
  proj.setting(:libdir, File.join(proj.prefix, 'lib'))
  proj.setting(:includedir, File.join(proj.prefix, "include"))
  proj.setting(:datadir, File.join(proj.prefix, "share"))
  proj.setting(:mandir, File.join(proj.datadir, "man"))

  proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby"))
  proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem"))

  ruby_base_version = proj.ruby_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2.0')
  proj.setting(:gem_home, File.join(proj.libdir, 'ruby', 'gems', ruby_base_version))
  proj.setting(:gem_install, "#{proj.host_gem} install --no-document --local --bindir=#{proj.ruby_bindir}")

  proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
  proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

  # Define default CFLAGS and LDFLAGS for most platforms, and then
  # tweak or adjust them as needed.
  proj.setting(:cppflags, "-I#{proj.includedir} -I/opt/pl-build-tools/include")
  proj.setting(:cflags, "#{proj.cppflags}")
  proj.setting(:ldflags, "-L#{proj.libdir} -L/opt/pl-build-tools/lib -Wl,-rpath=#{proj.libdir}")

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
  #

  # rubygem-net-ssh included in shared-agent-components
  proj.setting(:rubygem_net_ssh_version, '5.2.0')

  ########
  # Load shared agent components
  # When we want to run Bolt from the pe-installer package, we want our
  # puppet to have the same gems as the default puppet agent install.
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))


  # pl-build-tools
  proj.component 'runtime-pe-installer'

  # R10k dependencies
  proj.component 'rubygem-gettext-setup'

  # net-ssh dependencies for el8's OpenSSH default key format
  proj.component 'rubygem-bcrypt_pbkdf'
  proj.component 'rubygem-ed25519'

  # main puppet agent components
  # boost and yaml-cpp omitted since we don't need
  # pxp-agent deps
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-httpclient'
  proj.component 'rubygem-thor'
  proj.component 'rubygem-sys-filesystem'

  # What to include in package?
  proj.directory proj.prefix

  # Export the settings for the current project and platform as yaml during builds
  proj.publish_yaml_settings

  proj.timeout 7200 if platform.is_windows?
end
