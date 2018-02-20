component "rubygem-gettext-setup" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "0.30"
  pkg.md5sum "b7de0e7af0f56ddc55c88435ee95fd47"

  pkg.url "https://rubygems.org/downloads/gettext-setup-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/gettext-setup-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} gettext-setup-#{pkg.get_version}.gem"]
  end
end
