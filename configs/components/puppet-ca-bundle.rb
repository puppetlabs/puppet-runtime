component "puppet-ca-bundle" do |pkg, settings, platform|
  pkg.load_from_json("configs/components/puppet-ca-bundle.json")

  pkg.build_requires "openssl-#{settings[:openssl_version]}"

  if platform.is_cross_compiled_linux?
    # Use the build host's openssl command, not our cross-compiled or vendored one
    openssl_cmd = '/usr/bin/openssl'
  else
    openssl_cmd = "#{settings[:bindir]}/openssl"
  end

  target = if platform.is_fips?
             'install-fips'
           else
             'install'
           end

  install_commands = [
    "#{platform[:make]} #{target} OPENSSL=#{openssl_cmd} USER=0 GROUP=0 DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
  ]

  pkg.install do
    install_commands
  end
end
