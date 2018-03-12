project 'agent-runtime-1.10.x' do |proj|
  proj.inherit_settings 'puppet-agent', 'git://github.com/puppetlabs/puppet-agent', '1.10.x'

  proj.setting :augeas_version, '1.4.0'
  proj.setting :rubygem_fast_gettext_version, '1.1.0'
  proj.setting :rubygem_ffi_version, '1.9.14'
  proj.setting :ruby_stomp_version, '1.3.3'

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))

  proj.version proj.settings[:package_version]
end
