project 'pdk-runtime' do |proj|
  # Used in component configurations to conditionally include dependencies
  proj.setting(:runtime_project, "pdk")
  platform = proj.get_platform

  proj.inherit_settings 'pdk', 'git://github.com/puppetlabs/pdk-vanagon', 'master'
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

  # What to build?
  # --------------

  # Common deps
  proj.component "openssl-pdk"
  proj.component "curl"

  # Git and deps
  proj.component "git"

  # Ruby and deps
  proj.component "runtime-pdk"
  proj.component "puppet-ca-bundle"
  proj.component "ruby-#{proj.ruby_version}"
  proj.component "augeas" unless platform.is_windows?
  proj.component "libxml2" unless platform.is_windows?
  proj.component "libxslt" unless platform.is_windows?
  proj.component "ruby-augeas" unless platform.is_windows?
  # We only build ruby-selinux for EL 5-7
  if platform.name =~ /^el-(5|6|7)-.*/ || platform.is_fedora?
    proj.component "ruby-selinux"
  end
  proj.component "ruby-stomp-1.4.4"

  # Platform specific deps
  proj.component "ansicon" if platform.is_windows?

  # What to include in package?
  proj.directory proj.install_root
  proj.directory proj.prefix
  proj.directory proj.link_bindir unless platform.is_windows?

  proj.timeout 7200 if platform.is_windows?

  # Here we rewrite public http urls to use our internal source host instead.
  # Something like https://www.openssl.org/source/openssl-1.0.0r.tar.gz gets
  # rewritten as
  # https://artifactory.delivery.puppetlabs.net/artifactory/generic/buildsources/openssl-1.0.0r.tar.gz
  proj.register_rewrite_rule 'http', proj.buildsources_url
end
