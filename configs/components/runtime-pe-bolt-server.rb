# This component exists to install project-wide build dependencies for pe-bolt-server projects
component "runtime-pe-bolt-server" do |pkg, settings, platform|
  # PE Bolt Server depends on puppet-agent - it uses the agent's ruby installation to build gems.
  # Add the enterprise repo for this project's PE version so that puppet-agent can be installed as a build dependency:
  if platform.name =~ /ubuntu-18\.04/
    # The PE development repos are unsigned. Ubuntu 18.04's version of apt requires some configuration
    # to allow installing from them. This must happen before adding the repo configs below.
    platform.provision_with "echo 'Acquire::AllowInsecureRepositories \"true\";' > /etc/apt/apt.conf.d/90insecure"
  end

  artifactory_url = 'https://artifactory.delivery.puppetlabs.net/artifactory'

  if platform.is_rpm?
    platform.add_build_repository "https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-agent/0ca106596dfb1bb1509e0a7b1c09e6e6907bd6fe/puppet-agent-8.0.0.203.g0ca106596-1.el7.x86_64.rpm"
  end

  if platform.is_deb?
    platform.add_build_repository "#{artifactory_url}/debian_enterprise__local/#{settings[:pe_version]}/repos/#{platform.name}/#{platform.name}.list"
  end

  pkg.build_requires('puppet-agent')
end
