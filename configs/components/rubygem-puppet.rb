component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.environment "GEM_HOME", settings[:gem_home]
  pkg.environment "GEM_PATH", settings[:gem_home]
  pkg.url("https://nightlies.puppet.com/downloads/gems/puppet8-nightly/puppet-latest.gem")
  pkg.md5sum("5db00a0e81209b034fe2f5412f01e28c")

  pkg.install do
    [
    "#{settings[:gem_install]} puppet-*.gem",
    ]
  end
end

