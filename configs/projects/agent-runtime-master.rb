project 'agent-runtime-master' do |proj|
  proj.inherit_settings 'puppet-agent', 'git://github.com/puppetlabs/puppet-agent', 'master'

  proj.setting :augeas_version, '1.10.1'

  # Common agent settings:
  instance_eval File.read('configs/projects/base-agent-runtime.rb')

  proj.version proj.settings[:package_version]

  # Dependencies specific to the master branch
  proj.component 'ruby-stomp-1.4.4'
end
