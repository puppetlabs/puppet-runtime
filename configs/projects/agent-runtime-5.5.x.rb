project 'agent-runtime-5.5.x' do |proj|
  # Set preferred component versions if they differ from defaults:
  proj.setting :augeas_version, '1.10.1'
  proj.setting :ruby_version, '2.4.4'
  proj.setting :rubygem_net_ssh, '4.1.0'
  proj.setting :rubygem_semantic_puppet_version, '0.1.2'
  proj.setting :openssl_version, '1.0.2'

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Settings specific to the 5.5.x branch
  ########

  # Directory for gems shared by puppet and puppetserver
  proj.setting(:puppet_gem_vendor_dir, File.join(proj.libdir, "ruby", "vendor_gems"))

  ########
  # Load shared agent components
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))

  ########
  # Components specific to the 5.5.x branch
  ########

  proj.component 'rubygem-gettext-setup'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-trollop'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'ruby-stomp'
end
