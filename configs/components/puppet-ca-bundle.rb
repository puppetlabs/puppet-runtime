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

  # Include the keystore for the agent if the agent has a java
  if settings[:runtime_project] == 'agent'
    if platform.name =~ /el-(6|7|8)|sles-(11|12)|debian-(9|10)|ubuntu-(14|15|16|18)/
      install_commands << "#{platform[:make]} keystore OPENSSL=#{openssl_cmd} DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
    end
  end

  pkg.install do
    install_commands
  end
end
