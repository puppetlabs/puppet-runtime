project 'pe-bolt-server-runtime-main' do |proj|
  proj.setting(:pe_version, 'main')
  proj.setting(:rubygem_puppet_version, '8.6.0')
  # We build bolt server with the ruby installed in the puppet-agent dep. For ruby 2.7 we need to use a --no-document flag
  # for gem installs instead of --no-ri --no-rdoc. This setting allows us to use this while we support both ruby 2.5 and 2.7
  # Once we are no longer using ruby 2.5 we can update.
  proj.setting(:no_doc, true)

  proj.setting(:ruby_version, '3.2.4')
  proj.setting(:openssl_version, '3.0')

  # We enable legacy algorithms for winrm transport. Currently the winrm transport
  # does not work on FIPS, so in order to stay compliant we do not enable legacy algorithms
  # on fips builds.
  if proj.get_platform.name =~ /^redhatfips/
    proj.setting(:use_legacy_openssl_algos, false)
  else 
    proj.setting(:use_legacy_openssl_algos, true)
  end

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server_with_ruby.rb'))
  proj.component 'rubygem-prime'
  proj.component 'rubygem-rexml'
end
