component "rubygem-mini_portile2" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "2.1.0"
  pkg.md5sum "d771975a58cef82daa6b0ee03522293f"
  pkg.url "https://rubygems.org/downloads/mini_portile2-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/mini_portile2-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} mini_portile2-#{pkg.get_version}.gem"]
  end
end
