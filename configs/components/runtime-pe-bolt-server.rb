# This component exists to install project-wide build dependencies for pe-bolt-server projects
component "runtime-pe-bolt-server" do |pkg, settings, platform|
  # PE Bolt Server depends on puppet-agent - it uses the agent's ruby installation to build gems.
  # Add the enterprise repo for this project's PE version so that puppet-agent can be installed as a build dependency:
  if platform.name =~ /ubuntu-18\.04/
    # The PE development repos are unsigned. Ubuntu 18.04's version of apt requires some configuration
    # to allow installing from them. This must happen before adding the repo configs below.
    platform.provision_with "echo 'Acquire::AllowInsecureRepositories \"true\";' > /etc/apt/apt.conf.d/90insecure"
  end

  platform.add_build_repository("http://enterprise.delivery.puppetlabs.net/#{settings[:pe_version]}/repos/#{platform.name}/#{platform.name}.repo")
  pkg.build_requires('puppet-agent')
end
