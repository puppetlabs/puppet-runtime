component "rubygem-gettext" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "3.2.2"
  pkg.md5sum "4cbb125f8d8206e9a8f3a90f6488e4da"
  pkg.url "https://rubygems.org/downloads/gettext-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/gettext-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} gettext-#{pkg.get_version}.gem"]
  end
end
