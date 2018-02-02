component "rubygem-text" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "1.3.1"
  pkg.md5sum "514c3d1db7a955fe793fc0cb149c164f"
  pkg.url "https://rubygems.org/downloads/text-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/text-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} text-#{pkg.get_version}.gem"]
  end
end
