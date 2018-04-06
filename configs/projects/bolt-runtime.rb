project 'bolt-runtime' do |proj|
  # Used in component configurations to conditionally include dependencies
  proj.setting(:runtime_project, 'bolt')
  proj.setting :ruby_version, '2.4.3'
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

  if platform.is_windows?
    proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby.exe"))
    proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem.bat"))
  else
    proj.setting(:host_ruby, File.join(proj.ruby_bindir, "ruby"))
    proj.setting(:host_gem, File.join(proj.ruby_bindir, "gem"))
  end

  ruby_base_version = proj.ruby_version.gsub(/(\d)\.(\d)\.(\d)/, '\1.\2.0')
  proj.setting(:gem_home, File.join(proj.libdir, 'ruby', 'gems', ruby_base_version))
  proj.setting(:gem_install, "#{proj.host_gem} install --no-rdoc --no-ri --local --bindir=#{proj.ruby_bindir}")

  proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
  proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

  # These flags are applied in addition to the defaults in configs/component/openssl.rb.
  proj.setting(:openssl_extra_configure_flags, [
    'no-dtls',
    'no-dtls1',
    'no-idea',
    'no-seed',
    'no-ssl2-method',
    'no-weak-ssl-ciphers',
    '-DOPENSSL_NO_HEARTBEATS',
  ])

  # What to build?
  # --------------

  # Common deps
  proj.component "openssl"
  proj.component "curl"

  # Ruby and deps
  proj.component "puppet-ca-bundle"
  proj.component "ruby-#{proj.ruby_version}"

  # Possibly optional Puppet dependencies
  proj.component 'rubygem-deep-merge'
  proj.component 'rubygem-text'
  proj.component 'rubygem-locale'
  proj.component 'rubygem-gettext'
  proj.component 'rubygem-fast_gettext'

  # Core dependencies
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-minitar'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-net-ssh'

  # Core Windows dependencies
  proj.component 'rubygem-win32-dir'
  proj.component 'rubygem-win32-process'
  proj.component 'rubygem-win32-security'
  proj.component 'rubygem-win32-service'

  # What to include in package?
  proj.directory proj.prefix

  proj.timeout 7200 if platform.is_windows?
end
