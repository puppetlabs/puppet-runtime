project 'agent-runtime-7.x' do |proj|

  # Set preferred component versions if they differ from defaults:
  proj.setting :ruby_version, '2.7.8'
  proj.setting :rubygem_deep_merge_version, '1.2.2'
  proj.setting :rubygem_fast_gettext_version, '1.1.2'
  proj.setting :rubygem_gettext_version, '3.2.2'
  proj.setting :rubygem_gettext_setup_version, '0.34'

  # Solaris and AIX depend on libedit which breaks augeas compliation starting with 1.13.0
  if platform.is_solaris? || platform.is_aix?
    proj.setting :augeas_version, '1.12.0'
  else
    proj.setting :augeas_version, '1.14.1'
  end

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Settings specific to the next branch
  ########

  # Directory for gems shared by puppet and puppetserver
  proj.setting(:puppet_gem_vendor_dir, File.join(proj.libdir, "ruby", "vendor_gems"))

  # Ruby 2.7 loads openssl on installation. Because pl-ruby was not
  # built with openssl support, we switch to compile with system
  # rubies.
  # Solaris 11 seems to work with pl-ruby, and 10 is handled in _shared-agent-settings.rb.
  if platform.is_cross_compiled_linux?
    proj.setting(:host_ruby, "/usr/bin/ruby")
  end

  # Ruby 2.6 (RubyGems 3.0.1) removed the --ri and --rdoc
  # options. Switch to using --no-document which is available starting
  # with RubyGems 2.0.0preview2. This should also cover cross-compiled
  # platforms that use older rubies.
  proj.setting(:gem_install, "#{proj.host_gem} install --no-document --local")

  ########
  # Load shared agent components
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))

  ########
  # Components specific to the main branch
  ########

  # When adding components to this list, please
  # add them to pe-installer-runtime-main as well
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-thor'
  proj.component 'rubygem-scanf'

  # We add rexml explicitly in here because even though ruby 3 ships with rexml as its default gem, the version
  # of rexml it ships with contains CVE-2024-41946, CVE-2024-41123, CVE-2024-35176 and CVE-2024-39908.
  # So, we add it here to update to a higher version
  # free from the CVEs.
  proj.component 'rubygem-rexml'

  if platform.is_linux?
    proj.component "virt-what"
    proj.component "dmidecode" unless platform.architecture =~ /ppc64/
  end

  unless platform.is_windows?
    proj.component 'rubygem-sys-filesystem'
  end

  # Nokogiri and dependencies to improve macOS performance (PUP-11332)
  if platform.is_macos?
    proj.component 'rubygem-nokogiri'
    proj.component 'rubygem-mini_portile2'
  end

  proj.component 'boost' if ENV['NO_PXP_AGENT'].to_s.empty?
  proj.component 'yaml-cpp' if ENV['NO_PXP_AGENT'].to_s.empty?
end
