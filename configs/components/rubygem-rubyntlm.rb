component 'rubygem-rubyntlm' do |pkg, settings, platform|
  pkg.environment "GEM_HOME", settings[:gem_home]
  pkg.environment "GEM_PATH", settings[:gem_home]
  pkg.url("https://github.com/larskanis/rubyntlm.git")
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
