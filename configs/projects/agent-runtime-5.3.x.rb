project 'agent-runtime-5.3.x' do |proj|
  # Set preferred component versions if they differ from defaults:
  proj.setting :ruby_version, '2.4.4'
  proj.setting :augeas_version, '1.8.1'
  proj.setting :openssl_version, '1.0.2'

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Load shared agent components
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))

  ########
  # Components specific to the 5.3.x branch
  ########

  proj.component 'rubygem-gettext-setup'
  proj.component 'ruby-stomp'
end
