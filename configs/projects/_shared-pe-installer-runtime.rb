platform = proj.get_platform
proj.version_from_git
proj.generate_archives true
proj.generate_packages false

proj.description "The PE Installer runtime contains third-party components needed for PE Installer standalone packaging"
proj.license "See components"
proj.vendor "Puppet, Inc.  <info@puppet.com>"
proj.homepage "https://puppet.com"
proj.identifier "com.puppetlabs"

# Used in component configurations to conditionally include dependencies
proj.setting(:runtime_project, 'pe-installer')

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

proj.setting(:augeas_version, '1.14.1')

########
# Load shared agent components
# When we want to run Bolt from the pe-installer package, we want our
# puppet to have the same gems as the default puppet agent install.
########
instance_eval File.read('configs/projects/_shared-agent-components.rb')

# pl-build-tools
proj.component 'runtime-pe-installer'

# Below are copied from pe-bolt-server, since we're shipping much the same thing.
# Deps in _shared-agent-components are removed, and we do not include the
# agent gem.

# R10k dependencies
proj.component('rubygem-gettext-setup')

# hiera-eyaml and its dependencies
proj.component('rubygem-highline')
proj.component('rubygem-optimist')
proj.component('rubygem-hiera-eyaml')

# faraday and its dependencies
proj.component('rubygem-faraday')
proj.component('rubygem-faraday-em_http')
proj.component('rubygem-faraday-em_synchrony')
proj.component('rubygem-faraday-excon')
proj.component('rubygem-faraday-httpclient')
proj.component('rubygem-faraday-multipart')
proj.component('rubygem-faraday-net_http')
proj.component('rubygem-faraday-net_http_persistent')
proj.component('rubygem-faraday-patron')
proj.component('rubygem-faraday-rack')
proj.component('rubygem-faraday-retry')
proj.component('rubygem-faraday_middleware')
proj.component('rubygem-ruby2_keywords')

# Core dependencies
proj.component('rubygem-addressable')
proj.component('rubygem-aws-eventstream')
proj.component('rubygem-aws-partitions')
proj.component('rubygem-aws-sdk-core')
proj.component('rubygem-aws-sdk-ec2')
proj.component('rubygem-aws-sigv4')
proj.component('rubygem-bcrypt_pbkdf')
proj.component('rubygem-bindata')
proj.component('rubygem-builder')
proj.component('rubygem-CFPropertyList')
proj.component('rubygem-colored2')
proj.component('rubygem-concurrent-ruby')
proj.component('rubygem-connection_pool')
proj.component('rubygem-cri')
proj.component('rubygem-ed25519')
proj.component('rubygem-erubi')
proj.component('rubygem-facter')
proj.component('rubygem-ffi')
proj.component('rubygem-gssapi')
proj.component('rubygem-gyoku')
proj.component('rubygem-hiera')
proj.component('rubygem-httpclient')
proj.component('rubygem-jmespath')
proj.component('rubygem-jwt')
proj.component('rubygem-little-plugger')
proj.component('rubygem-log4r')
proj.component('rubygem-logging')
proj.component('rubygem-minitar')
proj.component('rubygem-molinillo')
proj.component('rubygem-multi_json')
proj.component('rubygem-multipart-post')
proj.component('rubygem-net-http-persistent')
proj.component('rubygem-net-scp')
proj.component('rubygem-net-ssh-krb')
proj.component('rubygem-nori')
proj.component('rubygem-rubyntlm')
proj.component('rubygem-orchestrator_client')
proj.component('rubygem-public_suffix')
proj.component('rubygem-paint')
proj.component('rubygem-puppet_forge')
proj.component('rubygem-puppet-resource_api')
proj.component('rubygem-puppet-strings')
proj.component('rubygem-puppetfile-resolver')
proj.component('rubygem-r10k')
proj.component('rubygem-rgen')
proj.component('rubygem-rubyntlm')
proj.component('rubygem-ruby_smb')
proj.component('rubygem-rubyzip')
proj.component('rubygem-scanf')
proj.component('rubygem-terminal-table')
proj.component('rubygem-thor')
proj.component('rubygem-unicode-display_width')
proj.component('rubygem-webrick')
proj.component('rubygem-yard')

# Core Windows dependencies
proj.component('rubygem-windows_error')
proj.component('rubygem-winrm')
proj.component('rubygem-winrm-fs')

# What to include in package?
proj.directory proj.prefix

# Export the settings for the current project and platform as yaml during builds
proj.publish_yaml_settings

proj.timeout 7200 if platform.is_windows?
