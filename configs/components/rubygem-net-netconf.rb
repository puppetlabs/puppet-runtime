component "rubygem-net-netconf" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "0.4.3"
  pkg.md5sum "fa173b0965766a427d8692f6b31c85a4"
  pkg.url "https://rubygems.org/downloads/net-netconf-#{get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/net-netconf-#{pkg.get_version}.gem"

  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  pkg.build_requires "rubygem-net-scp"
  # We're force installing the gem to workaround issues we have with
  # the nokogiri gem, so there is no build_requires on rubygem-nokogiri

  pkg.install do
    ["#{settings[:gem_install]} --force net-netconf-#{pkg.get_version}.gem"]
  end
end
