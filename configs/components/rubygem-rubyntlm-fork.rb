component 'rubygem-rubyntlm-fork' do |pkg, settings, platform|
    #until we solve https://tickets.puppetlabs.com/browse/PE-36078 ship this fork of ruby-ntlm
    
    # This is only needed when building the gem ourselves, as the
    # gemspec file calls out to git for one of its values.
    pkg.build_requires 'git'
    pkg.environment "GEM_HOME", settings[:gem_home]
    pkg.environment "GEM_PATH", settings[:gem_home]
    pkg.url("https://github.com/nmburgan/rubyntlm.git")
    pkg.ref("openssl-3-legacy")
    pkg.build do
      ["#{settings[:gem_build]} rubyntlm.gemspec"]
    end
  
    pkg.install do
      [
      "#{settings[:gem_install]} rubyntlm-*.gem",
      ]
    end
  end