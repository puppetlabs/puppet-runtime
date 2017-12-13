project 'agent-runtime-1.10.x' do |proj|
  proj.inherit_settings 'puppet-agent', 'git://github.com/puppetlabs/puppet-agent', '1.10.x'
  # Common agent settings:
  instance_eval File.read('configs/projects/base-agent-runtime.rb')

  proj.version "#{proj.settings[:package_version]}"

  # Dependencies specific to the 1.10.x branch
  proj.component 'ruby-stomp-1.3.3'
end
