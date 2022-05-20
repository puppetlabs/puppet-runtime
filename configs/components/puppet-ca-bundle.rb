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

  pkg.install do
    install_commands
  end
end
