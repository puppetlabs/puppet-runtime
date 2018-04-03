component "rubygem-win32-dir" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "0.4.9"
  pkg.md5sum "df14aa01bd6011f4b6332a05e15b7fb8"
  pkg.url "https://rubygems.org/downloads/win32-dir-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/win32-dir-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} win32-dir-#{pkg.get_version}.gem"]
  end
end
