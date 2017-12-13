component "rubygem-fast_gettext" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "1.1.0"
  pkg.md5sum "fc0597bd4d84b749c579cc39c7ceda0f"
  pkg.url "https://rubygems.org/downloads/fast_gettext-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/fast_gettext-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} fast_gettext-#{pkg.get_version}.gem"]
  end
end
