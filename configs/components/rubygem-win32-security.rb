component "rubygem-win32-security" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "0.2.5"
  pkg.md5sum "97c4b971ea19ca48cea7dec1d21d506a"
  pkg.url "https://rubygems.org/downloads/win32-security-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/win32-security-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} win32-security-#{pkg.get_version}.gem"]
  end
end
