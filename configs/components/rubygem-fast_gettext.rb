component "rubygem-fast_gettext" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "1.1.2"
  pkg.md5sum "df5a2462d0e1d2e5d49bb233b841f4d6"
  pkg.url "https://rubygems.org/downloads/fast_gettext-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/fast_gettext-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} fast_gettext-#{pkg.get_version}.gem"]
  end
end
