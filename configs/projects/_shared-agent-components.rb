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

matchdata = platform.settings[:ruby_version].match(/(\d+)\.\d+\.\d+/)
ruby_major_version = matchdata[1].to_i
# Ruby 3.2 does not package these two libraries so we need to add them as a component
if ruby_major_version >= 3
  proj.component 'libffi'
  proj.component 'libyaml'
end

if proj.openssl_version =~ /^3\./
  proj.component "openssl-#{proj.openssl_version}"
elsif platform.name =~ /^redhatfips-.*/
  proj.component "openssl-1.1.1-fips"
else
  proj.component "openssl-fips-2.0.16" if platform.name =~ /windowsfips-2012r2/ && proj.openssl_version =~ /1.0.2/
  proj.component "openssl-#{proj.openssl_version}"
end

proj.component 'curl'
proj.component 'puppet-ca-bundle'
proj.component "ruby-#{proj.ruby_version}"
proj.component "readline" if platform.is_macos?
proj.component 'augeas' unless platform.is_windows?
proj.component 'libxml2' unless platform.is_windows?
proj.component 'libxslt' unless platform.is_windows?

proj.component 'ruby-augeas' unless platform.is_windows?
proj.component 'ruby-shadow' unless platform.is_aix? || platform.is_windows?
# We only build ruby-selinux for EL, Fedora, Debian and Ubuntu (amd64/i386)
if platform.is_el? || platform.is_fedora? || platform.is_debian? || (platform.is_ubuntu? && platform.architecture !~ /ppc64el$/)
  proj.component 'ruby-selinux'
end

# libedit is used instead of readline on these platforms
if platform.is_solaris? || platform.name == 'aix-7.1-ppc'
  proj.component 'libedit'
end

proj.component 'pl-ruby-patch' if platform.is_cross_compiled?

proj.component 'rubygem-hocon'
proj.component 'rubygem-deep_merge'
proj.component 'rubygem-net-ssh'
proj.component 'rubygem-semantic_puppet'
proj.component 'rubygem-text'
proj.component 'rubygem-locale'
proj.component 'rubygem-gettext'
proj.component 'rubygem-fast_gettext'
proj.component 'rubygem-ffi'
proj.component 'rubygem-rexml'

if platform.is_windows? || platform.is_solaris? || platform.is_aix?
  proj.component 'rubygem-minitar'
end

if platform.is_macos?
  proj.component 'rubygem-CFPropertyList'
end
