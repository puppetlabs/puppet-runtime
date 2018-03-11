# This project is designed for reuse by branch-specific agent-runtime configs;
# See configs/projects/agent-runtime-<branchname>.rb
unless defined?(proj)
  warn('This is the base project for the puppet-agent runtime.')
  warn('Please choose one of `puppet-agent-master`, `puppet-agent-5.3.x`, or `puppet-agent-1.10.x` instead.')
  exit 1
end

# Used in component configurations to conditionally include dependencies
proj.setting(:runtime_project, 'agent')

proj.generate_archives true
proj.generate_packages false

proj.description 'The puppet agent runtime contains third-party components needed for the puppet agent'
proj.license 'See components'
proj.vendor 'Puppet, Inc.  <info@puppet.com>'
proj.homepage 'https://puppet.com'

# Some projects and platforms using the runtime set custom ruby installation
# directories - fall back to the project prefix if ruby_dir hasn't been set
proj.setting(:ruby_dir, proj.settings[:prefix]) unless proj.settings[:ruby_dir]
proj.setting(:ruby_bindir, File.join(proj.settings[:ruby_dir], 'bin')) unless proj.settings[:ruby_bindir]

if platform.is_macos?
  proj.identifier 'com.puppetlabs'
end

# Common components required by all agent branches
proj.component 'runtime-agent'

if platform.name =~ /^redhat-fips-7-.*/
  # Link against the system openssl instead of our vendored version:
  proj.setting(:system_openssl, true)
else
  proj.component 'openssl'
end

proj.component 'curl'
proj.component 'puppet-ca-bundle'
proj.component "ruby-#{proj.ruby_version}"
proj.component 'augeas' unless platform.is_windows?
proj.component 'libxml2' unless platform.is_windows?
proj.component 'libxslt' unless platform.is_windows?
proj.component 'ruby-augeas' unless platform.is_windows?
proj.component 'ruby-shadow' unless platform.is_aix? || platform.is_windows?
# We only build ruby-selinux for EL 5-7
if platform.name =~ /^el-(5|6|7)-.*/ || platform.is_fedora?
  proj.component 'ruby-selinux'
end

# libedit is used instead of readline on these platforms
if platform.is_aix? || platform.is_solaris?
  proj.component 'libedit'
end

proj.component 'rubygem-deep-merge'
proj.component 'rubygem-net-ssh'
proj.component 'rubygem-hocon'
proj.component 'rubygem-semantic_puppet'
proj.component 'rubygem-text'
proj.component 'rubygem-locale'
proj.component 'rubygem-gettext'
proj.component 'rubygem-fast_gettext'
proj.component 'rubygem-gettext-setup'

if platform.is_windows?
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-win32-dir'
  proj.component 'rubygem-win32-process'
  proj.component 'rubygem-win32-security'
  proj.component 'rubygem-win32-service'
  proj.component 'rubygem-win32-eventlog'
end

if platform.is_windows? || platform.is_solaris?
  proj.component 'rubygem-minitar'
end

# Commmon platform-specific settings for all agent branches:
platform = proj.get_platform

# What to include in package?
proj.directory proj.install_root
proj.directory proj.prefix
proj.directory proj.sysconfdir
proj.directory proj.link_bindir
proj.directory proj.logdir unless platform.is_windows?
proj.directory proj.piddir unless platform.is_windows?
if platform.is_windows? || platform.is_macos?
  proj.directory proj.bindir
end

proj.timeout 7200 if platform.is_windows?
