project 'agent-runtime-master' do |proj|
  # Set preferred component versions if they differ from defaults:
  proj.setting :ruby_version, '2.5.7'
  proj.setting :augeas_version, '1.12.0'
  proj.setting :openssl_version, platform.name =~ /windowsfips-2012r2/ ? '1.0.2' : '1.1.1'

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Settings specific to the master branch
  ########

  # Directory for gems shared by puppet and puppetserver
  proj.setting(:puppet_gem_vendor_dir, File.join(proj.libdir, "ruby", "vendor_gems"))

  ########
  # Load shared agent components
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))

  ########
  # Components specific to the master branch
  ########

  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-httpclient'
  proj.component 'rubygem-thor'

  unless platform.is_windows? || platform.is_aix? || platform.is_solaris?
    proj.component 'rubygem-sys-filesystem'
  end

  # SLES 15 uses the OS distro versions of boost and yaml-cpp:
  proj.component 'boost' unless platform.name =~ /sles-15/
  proj.component 'yaml-cpp' unless platform.name =~ /sles-15/
end
