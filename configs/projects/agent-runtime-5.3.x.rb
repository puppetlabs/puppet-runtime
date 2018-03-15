project 'agent-runtime-5.3.x' do |proj|
  proj.setting :ruby_version, '2.4.3'
  proj.setting :augeas_version, '1.8.1'

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))

  # Dependencies specific to the 5.3.x branch
  proj.component 'ruby-stomp-1.4.4'
end
