# This component exists to install project-wide build dependencies for pe-bolt-server projects
component "runtime-pe-bolt-server" do |pkg, settings, platform|

  builtin_ruby ||= settings[:builtin_ruby]

  # PE Bolt Server depends on puppet-agent - it uses the agent's ruby installation to build gems.
  # Add the enterprise repo for this project's PE version so that puppet-agent can be installed as a build dependency:
  if platform.name =~ /ubuntu-18\.04/
    # The PE development repos are unsigned. Ubuntu 18.04's version of apt requires some configuration
    # to allow installing from them. This must happen before adding the repo configs below.
    platform.provision_with "echo 'Acquire::AllowInsecureRepositories \"true\";' > /etc/apt/apt.conf.d/90insecure"
  end

  artifactory_url = 'https://artifactory.delivery.puppetlabs.net/artifactory'

  if platform.is_rpm?
    platform.add_build_repository "#{artifactory_url}/rpm_enterprise__local/#{settings[:pe_version]}/repos/#{platform.name}/#{platform.name}.repo"
  end

  if platform.is_deb?
    platform.add_build_repository "#{artifactory_url}/debian_enterprise__local/#{settings[:pe_version]}/repos/#{platform.name}/#{platform.name}.list"
  end

  pkg.build_requires('puppet-agent')
  if builtin_ruby
    pkg.build_requires "libffi"
    pkg.build_requires "libyaml"

    # PROJECT_SHORTNAME is used in the runtime script to determine the
    # libdir where we put all the linked lib files. For bolt-server there's
    # a whole path it needs to follow instead of just a name like 'installer'
    # or 'bolt'.
    pkg.environment "PROJECT_SHORTNAME", "server/apps/bolt-server"
    pkg.add_source "file://resources/files/runtime/runtime.sh"
    if platform.name =~ /el-[567]|redhatfips-7|sles-(11|12)|ubuntu-18.04-amd64/
      libbase = platform.architecture =~ /64/ ? 'lib64' : 'lib'
      libdir = "/opt/pl-build-tools/#{libbase}"
      pkg.install do
        "bash runtime.sh #{libdir}"
      end
    end
  end
end
