project 'agent-runtime-1.10.x' do |proj|
  proj.setting :ruby_version, '2.1.9'
  proj.setting :augeas_version, '1.4.0'
  proj.setting :rubygem_fast_gettext_version, '1.1.0'
  proj.setting :rubygem_ffi_version, '1.9.14'
  proj.setting :ruby_stomp_version, '1.3.3'
  proj.component 'rubygem-gettext-setup'

  # The 1.10.x agent's openssl configure flags are slightly different from higher versions:
  # These flags are applied in addition to the defaults in configs/component/openssl.rb.
  proj.setting(:openssl_extra_configure_flags, [
    'enable-cms',
    'enable-seed',
    'no-gost',
    'no-rc5',
    'no-srp',
    'no-ssl2-method',
  ])

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))
end
