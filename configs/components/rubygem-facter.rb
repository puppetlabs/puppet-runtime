component 'rubygem-facter' do |pkg, settings, platform|
  pkg.environment "GEM_HOME", settings[:gem_home]
  pkg.environment "GEM_PATH", settings[:gem_home]
  pkg.url("https://nightlies.puppet.com/downloads/gems/facter-nightly/facter-latest.gem")
  pkg.md5sum("1e2c5b08cfc7a6d453af283ca8f53e37")

  pkg.install do
    [
    "#{settings[:gem_install]} facter-*.gem",
    ]
  end
end

