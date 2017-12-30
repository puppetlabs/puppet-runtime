project 'agent-runtime-5.3.x' do |proj|
  proj.inherit_settings 'puppet-agent', 'git://github.com/puppetlabs/puppet-agent', '5.3.x'
  # Common agent settings:
  instance_eval File.read('configs/projects/base-agent-runtime.rb')

  proj.version "#{proj.settings[:package_version]}"

  # Dependencies specific to the 5.3.x branch
  proj.component 'ruby-stomp-1.4.4'
end
