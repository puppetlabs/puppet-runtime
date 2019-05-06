project 'pe-bolt-server-runtime-2019.0.x' do |proj|
  # Used in component configurations to conditionally include dependencies
  proj.setting(:runtime_project, 'pe-bolt-server')
  proj.setting(:rubygem_minitar_version, '0.8')
  proj.setting(:pe_version, '2019.0')

  proj.version_from_git
  proj.generate_archives true
  proj.generate_packages false

  proj.description 'The PE Bolt runtime contains third-party components needed for PE Bolt server packaging'
  proj.license 'See components'
  proj.vendor 'Puppet, Inc.  <info@puppet.com>'
  proj.homepage 'https://puppet.com'
  proj.identifier 'com.puppetlabs'

  proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
  proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

  # (pe-bolt-server does not run on Windows, so only the *nix path is here)
  proj.setting(:prefix, '/opt/puppetlabs/server/apps/bolt-server')
  proj.setting(:bindir, File.join(proj.prefix, 'bin'))
  proj.setting(:libdir, File.join(proj.prefix, 'lib'))

  # Set the paths to ruby executables so that they match puppet-agent's:
  proj.setting(:ruby_dir, '/opt/puppetlabs/puppet')  # this is puppet-agent's prefix
  proj.setting(:ruby_bindir, File.join(proj.ruby_dir, 'bin'))
  proj.setting(:host_ruby, File.join(proj.ruby_bindir, 'ruby'))
  proj.setting(:host_gem, File.join(proj.ruby_bindir, 'gem'))
  proj.setting(:gem_build, "#{proj.host_gem} build")

  # These gem_* paths are specific to pe-bolt-server -- they allow gems built for this runtime to be
  # installed to pe-bolt-server's paths instead of puppet-agent's:
  proj.setting(:gem_install, "#{proj.host_gem} install --no-rdoc --no-ri --local --bindir=#{proj.bindir}")
  proj.setting(:gem_home, File.join(proj.libdir, 'ruby'))


  # What to build?
  # --------------

  # pe-bolt-server does not ship with its own ruby -- it depends on puppet-agent's ruby installation
  # and uses the agent's ruby to build gems.
  # This component installs puppet-agent as a build dependency:
  proj.component 'runtime-pe-bolt-server'

  # R10k dependencies
  proj.component 'rubygem-gettext-setup'

  # Core dependencies
  proj.component 'rubygem-addressable'
  proj.component 'rubygem-bcrypt_pbkdf'
  proj.component 'rubygem-bindata'
  proj.component 'rubygem-builder'
  proj.component 'rubygem-CFPropertyList'
  proj.component 'rubygem-colored'
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-connection_pool'
  proj.component 'rubygem-cri'
  proj.component 'rubygem-docker-api'
  proj.component 'rubygem-ed25519'
  proj.component 'rubygem-erubis'
  proj.component 'rubygem-excon'
  proj.component 'rubygem-facter'
  proj.component 'rubygem-faraday'
  proj.component 'rubygem-faraday_middleware'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-gssapi'
  proj.component 'rubygem-gyoku'
  proj.component 'rubygem-hiera'
  proj.component 'rubygem-hocon'
  proj.component 'rubygem-httpclient'
  proj.component 'rubygem-little-plugger'
  proj.component 'rubygem-log4r'
  proj.component 'rubygem-logging'
  proj.component 'rubygem-minitar'
  proj.component 'rubygem-multipart-post'
  proj.component 'rubygem-net-http-persistent'
  proj.component 'rubygem-net-scp'
  proj.component 'rubygem-nori'
  proj.component 'rubygem-orchestrator_client'
  proj.component 'rubygem-public_suffix'
  proj.component 'rubygem-puppet'
  proj.component 'rubygem-puppet_forge'
  proj.component 'rubygem-puppet-resource_api'
  proj.component 'rubygem-r10k'
  proj.component 'rubygem-rubyntlm'
  proj.component 'rubygem-ruby_smb'
  proj.component 'rubygem-rubyzip'
  proj.component 'rubygem-terminal-table'
  proj.component 'rubygem-unicode-display_width'

  # Core Windows dependencies
  proj.component 'rubygem-windows_error'
  proj.component 'rubygem-winrm'
  proj.component 'rubygem-winrm-fs'

  # Export the settings for the current project and platform as yaml during builds
  proj.publish_yaml_settings

  if platform.name =~ /^el-(8)-.*/
    # Disable build-id generation since it's currently generating conflicts
    # with system libgcc and libstdc++
    proj.package_override("# Disable build-id generation to avoid conflicts\n%global _build_id_links none")
  end

  proj.directory(proj.prefix)
end

