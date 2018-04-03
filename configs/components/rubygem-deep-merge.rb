component "rubygem-deep-merge" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "1.0.1"
  pkg.md5sum "6f30bc4727f1833410f6a508304ab3c1"
  pkg.url "https://rubygems.org/downloads/deep_merge-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/deep_merge-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} deep_merge-#{pkg.get_version}.gem"]
  end
end
