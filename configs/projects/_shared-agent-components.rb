# This "project" is designed to be shared by all puppet-agent projects
# See configs/projects/agent-runtime-<branchname>.rb
unless defined?(proj)
  warn('These are components shared by all puppet-agent projects; They cannot be built as a standalone project.')
  warn('Please choose one of the other puppet-agent projects instead.')
  exit 1
end

########
# Common components for all versions of puppet-agent
########

# Common components required by all agent branches
proj.component 'runtime-agent'

unless proj.settings[:system_openssl]
  proj.component "openssl-fips-2.0.16" if platform.name =~ /windowsfips-2012r2/ && proj.openssl_version =~ /1.0.2/
  proj.component "openssl-#{proj.openssl_version}"
end

proj.component 'curl'
proj.component 'puppet-ca-bundle'
proj.component "ruby-#{proj.ruby_version}"
proj.component 'augeas' unless platform.is_windows?
proj.component 'libxml2' unless platform.is_windows?
proj.component 'libxslt' unless platform.is_windows?

proj.component 'ruby-augeas' unless platform.is_windows?
proj.component 'ruby-shadow' unless platform.is_aix? || platform.is_windows?
# We only build ruby-selinux for EL, Fedora, Debian and Ubuntu (amd64/i386)
if platform.is_el? || platform.is_fedora? || platform.name =~ /debian|ubuntu/
  if platform.name !~ /ubuntu-.*-ppc64el|ubuntu-14.04/
    proj.component 'ruby-selinux'
  end
end

# libedit is used instead of readline on these platforms
if platform.is_solaris? || platform.is_aix?
  proj.component 'libedit'
end

proj.component 'rubygem-hocon'
proj.component 'rubygem-deep_merge'
proj.component 'rubygem-net-ssh'
proj.component 'rubygem-semantic_puppet'
proj.component 'rubygem-text'
proj.component 'rubygem-locale'
proj.component 'rubygem-gettext'
proj.component 'rubygem-fast_gettext'

proj.component 'rubygem-ffi'
if platform.is_windows? || platform.is_solaris?
  proj.component 'rubygem-minitar'
end

if platform.is_windows?
  proj.component 'rubygem-win32-dir'
  proj.component 'rubygem-win32-process'
  proj.component 'rubygem-win32-security'
  proj.component 'rubygem-win32-service'
end

if platform.is_macos?
  proj.component 'rubygem-CFPropertyList'
end
