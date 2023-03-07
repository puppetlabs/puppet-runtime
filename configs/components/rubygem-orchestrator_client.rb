component 'rubygem-orchestrator_client' do |pkg, settings, platform|
  pkg.environment "GEM_HOME", settings[:gem_home]
  pkg.environment "GEM_PATH", settings[:gem_home]
  pkg.url("https://github.com/donoghuc/orchestrator_client-ruby.git")
  pkg.ref("ruby-3.2")

  pkg.build do
    ["#{settings[:gem_build]} orchestrator_client.gemspec"]
  end

  pkg.install do
    [
    "#{settings[:gem_install]} orchestrator_client-*.gem",
    ]
  end
end
