component "rubygem-semantic_puppet" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "0.1.2"
  pkg.md5sum "192ae7729997cb5d5364f64b99b13121"
  pkg.url "https://rubygems.org/downloads/semantic_puppet-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/semantic_puppet-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} semantic_puppet-#{pkg.get_version}.gem"]
  end
end
