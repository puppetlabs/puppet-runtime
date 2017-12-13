component "rubygem-gettext-setup" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "0.28"
  pkg.md5sum "65c8e2bb3fe8e07b91f8ea9f0b4c2196"
  pkg.url "https://rubygems.org/downloads/gettext-setup-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/gettext-setup-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} gettext-setup-#{pkg.get_version}.gem"]
  end
end
