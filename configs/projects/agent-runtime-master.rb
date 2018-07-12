project 'agent-runtime-master' do |proj|
  # Set preferred component versions if they differ from defaults:
  proj.setting :ruby_version, '2.4.4'
  proj.setting :augeas_version, '1.10.1'

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

  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-trollop'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-httpclient'
  proj.component 'boost'
  proj.component 'yaml-cpp'
end
