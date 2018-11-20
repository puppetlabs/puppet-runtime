project 'agent-runtime-5.3.x' do |proj|
  # Set preferred component versions if they differ from defaults:
  proj.setting :augeas_version, '1.8.1'
  proj.setting :ruby_version, '2.4.5'
  proj.setting :rubygem_semantic_puppet_version, '0.1.2'
  proj.setting :openssl_version, '1.0.2'

  # In puppet-agent#master, install paths have been updated to more closely
  # match those used for *nix agents -- Use the old path style for this project:
  proj.setting :legacy_windows_paths, true

  platform = proj.get_platform

  # This modification to the platform definition is for compatibility with
  # pre-puppet6 puppet-agent packaging. Fedora platforms for puppet5 must have
  # have an `f` prefix before their version numbers and do not use an explicit
  # .dist string.
  if platform.name =~ /^fedora-([\d]+)/
    platform.instance_variable_set(:@name, platform.name.sub(/\d+/, 'f\\0'))
    platform.instance_variable_set(:@dist, nil)
  end

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Load shared agent components
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))

  ########
  # Components specific to the 5.3.x branch
  ########

  proj.component 'rubygem-gettext-setup'
  proj.component 'ruby-stomp'
end
