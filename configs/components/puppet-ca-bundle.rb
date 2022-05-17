component "puppet-ca-bundle" do |pkg, settings, platform|
  pkg.load_from_json("configs/components/puppet-ca-bundle.json")

  unless settings[:system_openssl]
    pkg.build_requires "openssl-#{settings[:openssl_version]}"
  end

  if platform.is_cross_compiled_linux? || settings[:system_openssl]
    # Use the build host's openssl command, not our cross-compiled or vendored one
    openssl_cmd = '/usr/bin/openssl'
  else
    openssl_cmd = "#{settings[:bindir]}/openssl"
  end

  install_commands = [
    "#{platform[:make]} install OPENSSL=#{openssl_cmd} USER=0 GROUP=0 DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
  ]

  # Include the keystore for the agent if the agent has a java and is NOT FIPS
  if settings[:runtime_project] == 'agent'
    # To build the type of FIPS compliant keystore PE uses requires the BCFIPS
    # library. It is assumed that FIPS users do not, in general, want their hosts
    # to easily connect to the larger Internet and so it is not worth the effort
    # to support FIPS keystores in the agent builds. 
    if platform.name !~ /fips/
      install_commands << "if [[ `which keytool` ]]; then #{platform[:make]} keystore OPENSSL=#{openssl_cmd} DESTDIR=#{File.join(settings[:prefix], 'ssl')}; fi"
    end
  end

  pkg.install do
    install_commands
  end
end
