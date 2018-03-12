project 'agent-runtime-5.5.x' do |proj|
  proj.inherit_settings 'puppet-agent', 'git://github.com/puppetlabs/puppet-agent', '5.5.x'

  proj.setting :augeas_version, '1.10.1'

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))

  proj.version proj.settings[:package_version]

  # Dependencies specific to the 5.5.x branch
  proj.component 'ruby-stomp-1.4.4'
end
