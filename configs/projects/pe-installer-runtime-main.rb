project 'pe-installer-runtime-main' do |proj|
  proj.setting(:ruby_version, '3.2.4')
  proj.setting(:openssl_version, '3.0')
  # NLTM uses MD4 unconditionally in its protocol, so legacy algos must be
  # enabled in OpenSSL >= 3.0 for Bolt's WinRM transport to work.
  # We DO NOT WANT legacy algos enabled for the Puppet Agent runtime.
  proj.setting(:use_legacy_openssl_algos, true)

  # rubygem-net-ssh included in shared-agent-components
  proj.setting(:rubygem_net_ssh_version, '7.2.3')
  proj.setting(:rubygem_puppet_version, '8.6.0')
  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-installer-runtime.rb'))
end
