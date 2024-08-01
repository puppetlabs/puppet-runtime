project 'pe-installer-runtime-2021.7.x' do |proj|
  proj.setting(:ruby_version, '2.7.8')
  # We need to explicitly define 1.1.1k here to avoid
  # build dep conflicts between openssl-1.1.1 needed by curl
  # and krb5-devel
  if platform.name =~ /^redhatfips-8/
    proj.setting(:openssl_version, '1.1.1k')
  else
    proj.setting(:openssl_version, '1.1.1')
  end
  
  # rubygem-net-ssh included in shared-agent-components
  proj.setting(:rubygem_net_ssh_version, '6.1.0')
  proj.setting(:rubygem_puppet_version, '7.32.1')
  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-installer-runtime.rb'))
end
