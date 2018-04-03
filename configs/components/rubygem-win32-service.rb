component "rubygem-win32-service" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "0.8.8"
  pkg.md5sum "24cc05fed398eb931e14b8ee22196634"
  pkg.url "https://rubygems.org/downloads/win32-service-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/win32-service-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} win32-service-#{pkg.get_version}.gem"]
  end
end
