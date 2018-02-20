project 'agent-runtime-1.10.x' do |proj|
  proj.inherit_settings 'puppet-agent', 'git://github.com/puppetlabs/puppet-agent', '1.10.x'

  proj.setting :augeas_version, '1.4.0'
  proj.setting :rubygem_fast_gettext_version, '1.1.0'

  # Common agent settings:
  instance_eval File.read('configs/projects/base-agent-runtime.rb')

  proj.version proj.settings[:package_version]

  # Dependencies specific to the 1.10.x branch
  proj.component 'ruby-stomp-1.3.3'
end
