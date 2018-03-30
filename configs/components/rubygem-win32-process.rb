component "rubygem-win32-process" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "0.7.5"
  pkg.md5sum "d7ff67c7934b0d6ab93030d2cc2fc4f0"
  pkg.url "https://rubygems.org/downloads/win32-process-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/win32-process-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} win32-process-#{pkg.get_version}.gem"]
  end
end
