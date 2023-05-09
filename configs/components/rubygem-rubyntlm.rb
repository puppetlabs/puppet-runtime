component 'rubygem-rubyntlm' do |pkg, settings, platform|
  #pkg.version '0.6.3'
  #pkg.md5sum 'e1f7477acf8a7d3effb2a3fb931aa84c'
  
  # This is only needed when building the gem ourselves, as the
  # gemspec file calls out to git for one of its values.
  pkg.build_requires 'git'
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

  #instance_eval File.read('configs/components/_base-rubygem.rb')
end
