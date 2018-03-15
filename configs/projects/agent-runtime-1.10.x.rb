project 'agent-runtime-1.10.x' do |proj|
  proj.setting :ruby_version, '2.1.9'
  proj.setting :augeas_version, '1.4.0'
  proj.setting :rubygem_fast_gettext_version, '1.1.0'
  proj.setting :rubygem_ffi_version, '1.9.14'

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))

  # Dependencies specific to the 1.10.x branch
  proj.component 'ruby-stomp-1.3.3'
end
