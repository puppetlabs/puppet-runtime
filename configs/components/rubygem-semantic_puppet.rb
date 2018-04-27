component "rubygem-semantic_puppet" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "1.0.2"
  pkg.md5sum "48f4a060e6004604e2f46716bfeabcdc"
  pkg.url "https://rubygems.org/downloads/semantic_puppet-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/semantic_puppet-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} semantic_puppet-#{pkg.get_version}.gem"]
  end
end
