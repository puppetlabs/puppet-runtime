project 'agent-runtime-5.3.x' do |proj|
  proj.setting :ruby_version, '2.4.4'
  proj.setting :augeas_version, '1.8.1'

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))

  # Dependencies specific to the 5.3.x branch
  proj.component 'rubygem-gettext-setup'
end
