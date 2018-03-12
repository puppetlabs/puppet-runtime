project 'agent-runtime-5.3.x' do |proj|
  proj.inherit_settings 'puppet-agent', 'git://github.com/puppetlabs/puppet-agent', '5.3.x'

  proj.setting :augeas_version, '1.8.1'

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))

  proj.version proj.settings[:package_version]
end
