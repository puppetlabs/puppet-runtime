# This "project" is a common basis for all pe-bolt-server branches. It should
# not be built on its own. Instead, other project files should load it with
# instance_eval. See configs/projects/pe-bolt-server-runtime-<branchname>.rb
# for branch-specific details.
unless defined?(proj)
  warn("'#{File.basename(__FILE__)}' is a set of basic configuration values" \
       " shared by all pe-bolt-server projects; It cannot be built as a" \
       " standalone project.")
  warn("Please choose one of the other pe-bolt-server projects instead.")
  exit(1)
end

pe_version = settings[:pe_version]
unless pe_version && !pe_version.empty?
  warn("You must set the `pe_version` setting in your pe-bolt-server project" \
       " file before instance_eval'ing '#{File.basename(__FILE__)}'. This should" \
       " be an x.y version like '2019.1' or similar.")
  exit(1)
end

proj.description('The PE Bolt runtime contains third-party components needed for PE Bolt server packaging')
proj.license('See components')
proj.vendor('Puppet, Inc.  <info@puppet.com>')
proj.homepage('https://puppet.com')
proj.identifier('com.puppetlabs')
proj.version_from_git
proj.generate_archives(true)
proj.generate_packages(false)

proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

# This setting can be used sparingly in component configurations to conditionally include dependencies:
proj.setting(:runtime_project, 'pe-bolt-server')

# Ruby + OpenSSL included with bolt-server
# --------------------------------------------
#
# Starting with pe-bolt-server packages installed next to Puppet 8
# pe-bolt-server now vendors its own ruby and openssl installation.
proj.setting(:builtin_ruby, true)

# Set desired versions for gem components that offer multiple versions:
# TODO: Can runtime projects use these updated versions?
proj.setting(:rubygem_deep_merge_version, '1.2.2')
proj.setting(:rubygem_net_ssh_version, '7.2.3')

# (pe-bolt-server does not run on Windows, so only the *nix path is here)
proj.setting(:prefix, '/opt/puppetlabs/server/apps/bolt-server')
proj.setting(:bindir, File.join(proj.prefix, 'bin'))
proj.setting(:libdir, File.join(proj.prefix, 'lib'))
proj.setting(:includedir, File.join(proj.prefix, "include"))

# proj.ruby_dir needs to be set by the individual versions of pe-bolt-server-runtime. Bolt-Server versions running
# alongside puppet 8 and later use their own ruby instead of the agent's.
proj.setting(:ruby_dir, proj.prefix)
proj.setting(:ruby_bindir, File.join(proj.ruby_dir, 'bin'))
proj.setting(:host_ruby, File.join(proj.ruby_bindir, 'ruby'))
proj.setting(:host_gem, File.join(proj.ruby_bindir, 'gem'))
proj.setting(:gem_build, "#{proj.host_gem} build")

# We build bolt server with the ruby installed in the puppet-agent dep. For ruby 2.7 we need to use a --no-document flag
# for gem installs instead of --no-ri --no-rdoc. This setting allows us to use this while we support both ruby 2.5 and 2.7
# Once we are no longer using ruby 2.5 we can update.
if proj.no_doc
  proj.setting(:gem_install, "#{proj.host_gem} install --no-document --local --bindir=#{proj.bindir}")
else
  proj.setting(:gem_install, "#{proj.host_gem} install --no-rdoc --no-ri --local --bindir=#{proj.bindir}")
end

proj.setting(:gem_cleanup, "#{proj.host_gem} cleanup")

proj.setting(:datadir, File.join(proj.prefix, "share"))
proj.setting(:mandir, File.join(proj.datadir, "man"))

ruby_base_version = proj.ruby_version.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2.0')
proj.setting(:gem_home, File.join(proj.libdir, 'ruby', 'gems', ruby_base_version))

# Define default CFLAGS and LDFLAGS for most platforms, and then
# tweak or adjust them as needed.
proj.setting(:cppflags, "-I#{proj.includedir} -I/opt/pl-build-tools/include")
proj.setting(:cflags, "#{proj.cppflags}")
proj.setting(:ldflags, "-L#{proj.libdir} -L/opt/pl-build-tools/lib -Wl,-rpath=#{proj.libdir}")

# Platform specific overrides or settings, which may override the defaults

# Harden Linux ELF binaries by compiling with PIE (Position Independent Executables) support,
# stack canary and full RELRO.
# We only do this on platforms that use their default OS toolchain since pl-gcc versions
# are too old to support these flags.
if platform.name =~ /sles-15|el-8|debian-10/ || platform.is_fedora?
  proj.setting(:cppflags, "-I#{proj.includedir} -D_FORTIFY_SOURCE=2")
  proj.setting(:cflags, '-fstack-protector-strong -fno-plt -O2')
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir},-z,relro,-z,now")
end

# Required to build ruby
proj.component 'libffi'
proj.component 'libyaml'

# Actually include the openssl/ruby components.
proj.component "openssl-#{proj.openssl_version}"
proj.component "ruby-#{proj.ruby_version}"

# What to build?
# --------------

# This component installs the puppet-agent build dependency:
proj.component('runtime-pe-bolt-server')

# R10k dependencies
proj.component('rubygem-gettext-setup')

# Puppet dependencies
proj.component 'rubygem-deep_merge'
proj.component 'rubygem-text'
proj.component 'rubygem-locale'
proj.component 'rubygem-gettext'
proj.component 'rubygem-fast_gettext'
proj.component 'rubygem-semantic_puppet'

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
proj.component('rubygem-hocon')
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
proj.component('rubygem-net-ssh')
proj.component('rubygem-net-ssh-krb')
proj.component('rubygem-nori')
proj.component('rubygem-rubyntlm')
proj.component('rubygem-orchestrator_client')
proj.component('rubygem-public_suffix')
proj.component('rubygem-paint')
proj.component('rubygem-puppet')
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

# Export the settings for the current project and platform as yaml during builds
proj.publish_yaml_settings

if platform.name =~ /^el-8-.*/
  # Disable build-id generation since it's currently generating conflicts
  # with system libgcc and libstdc++
  proj.package_override("# Disable build-id generation to avoid conflicts\n%global _build_id_links none")
end

proj.directory(proj.prefix)
