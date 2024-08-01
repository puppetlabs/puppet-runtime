project 'pe-bolt-server-runtime-2021.7.x' do |proj|
  proj.setting(:pe_version, '2021.7')
  proj.setting(:rubygem_puppet_version, '7.32.1')
  proj.setting(:rubygem_puppet_strings_version, '3.0.1')
  proj.setting(:rubygem_net_ssh_version, '6.1.0')
  # We build bolt server with the ruby installed in the puppet-agent dep. For ruby 2.7 we need to use a --no-document flag
  # for gem installs instead of --no-ri --no-rdoc. This setting allows us to use this while we support both ruby 2.5 and 2.7
  # Once we are no longer using ruby 2.5 we can update.
  proj.setting(:no_doc, true)

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server.rb'))
  proj.component 'rubygem-prime'
end
