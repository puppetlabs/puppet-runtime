component "puppet-ca-bundle" do |pkg, settings, platform|
  pkg.load_from_json("configs/components/puppet-ca-bundle.json")

  if settings[:system_openssl]
    pkg.build_requires 'openssl-devel'
  else
    pkg.build_requires 'openssl'
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

  # Include the keystore for the agent
  if settings[:runtime_project] == 'agent'
    java_available = true

    case platform.name
      when /el-(6|7)/
        pkg.build_requires 'java-1.8.0-openjdk-devel'
      when /(debian-(7|8)|ubuntu-14)/
        pkg.build_requires 'openjdk-7-jdk'
      when /(debian-9|ubuntu-(15|16))/
        pkg.build_requires 'openjdk-8-jdk'
      when /sles-12/
        pkg.build_requires 'java-1_7_0-openjdk-devel'
      when /sles-11/
        pkg.build_requires 'java-1_7_0-ibm-devel'
      else
        java_available = false
    end

    if java_available
      install_commands << "#{platform[:make]} keystore OPENSSL=#{openssl_cmd} DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
    end
  end

  pkg.install do
    install_commands
  end
end
