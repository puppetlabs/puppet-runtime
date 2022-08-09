project 'pe-bolt-server-runtime-2019.8.x' do |proj|
  proj.setting(:pe_version, '2019.8')
  proj.setting(:rubygem_puppet_version, '6.28.0')
  # We build bolt server with the ruby installed in the puppet-agent dep. For ruby 2.5 we need to use a --no-ri --no-rdoc flag
  # for gem installs instead of --no-document. This setting allows us to use this while we support both ruby 2.5 and 2.7
  # Once we are no longer using ruby 2.5 we can update.
  proj.setting(:no_doc, false)
  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server.rb'))

  # Ruby 2.5 does not include rexml as a vendored gem, so include it in 2019.8.x only.
  proj.component('rubygem-rexml')
end
