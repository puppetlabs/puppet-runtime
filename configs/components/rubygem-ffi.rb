component "rubygem-ffi" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.version '1.9.25'

  if platform.is_windows?
    if platform.architecture == "x64"
      pkg.md5sum "e263997763271fba35562245b450576f"
      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x64-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x64-mingw32.gem"
    else
      pkg.md5sum "3303124f1ca0ee3e59829301ffcad886"
      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x86-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x86-mingw32.gem"
    end

    pkg.install do
      ["#{settings[:gem_install]} ffi-#{pkg.get_version}-#{platform.architecture}-mingw32.gem"]
    end
  else
    pkg.md5sum "e8923807b970643d9e356a65038769ac"
    pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}.gem"
    pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}.gem"

    pkg.install do
      "#{settings[:gem_install]} ffi-#{pkg.get_version}.gem"
    end
  end
end
