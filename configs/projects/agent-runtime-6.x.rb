project 'agent-runtime-6.x' do |proj|
  # Set preferred component versions if they differ from defaults:
  proj.setting :ruby_version, '2.5.9'

  # Solaris and AIX depend on libedit which breaks augeas compliation starting with 1.13.0
  if platform.is_solaris? || platform.is_aix?
    proj.setting :augeas_version, '1.12.0'
  else
    proj.setting :augeas_version, '1.13.0'
  end

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Settings specific to the 6.x branch
  ########

  # Directory for gems shared by puppet and puppetserver
  proj.setting(:puppet_gem_vendor_dir, File.join(proj.libdir, "ruby", "vendor_gems"))

  ########
  # Load shared agent components
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))

  ########
  # Components specific to the 6.x branch
  ########

  # When adding components to this list, please
  # add them to pe-installer-runtime-2019.8.x as well
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-httpclient'
  proj.component 'rubygem-thor'

  unless platform.is_windows?
    proj.component 'rubygem-sys-filesystem'
  end

  proj.component 'boost'
  proj.component 'yaml-cpp'

  if platform.is_windows?
    proj.component 'rubygem-win32-dir'
    proj.component 'rubygem-win32-process'
    proj.component 'rubygem-win32-security'
    proj.component 'rubygem-win32-service'
  end
end
