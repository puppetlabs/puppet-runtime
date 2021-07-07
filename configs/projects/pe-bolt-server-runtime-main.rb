project 'pe-bolt-server-runtime-main' do |proj|
  proj.setting(:pe_version, 'main')
  # We build bolt server with the ruby installed in the puppet-agent dep. For ruby 2.7 we need to use a --no-document flag
  # for gem installs instead of --no-ri --no-rdoc. This setting allows us to use this while we support both ruby 2.5 and 2.7
  # Once we are no longer using ruby 2.5 we can update.
  proj.setting(:no_doc, true)
  proj.setting(:rubygem_puppet_version, '7.8.0')

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server.rb'))

  # Puppet 7 needs this gem
  proj.component 'rubygem-scanf'
end
