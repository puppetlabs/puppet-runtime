component "rubygem-ffi" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  version = settings[:rubygem_ffi_version] || '1.9.18'
  pkg.version version

  if platform.architecture == "x64"
    pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x64-mingw32.gem"
    pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x64-mingw32.gem"
  else
    pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x86-mingw32.gem"
    pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x86-mingw32.gem"
  end

  case version
    when '1.9.14'
      if platform.architecture == "x64"
        pkg.md5sum "6d78ae5b2378513d3fc68600981366e9"
      else
        pkg.md5sum "54a20f0f73d03c06adf63789faa53746"
      end
    when '1.9.18'
      if platform.architecture == "x64"
        pkg.md5sum "664afc6a316dd648f497fbda3be87137"
      else
        pkg.md5sum "0b6fd994826952231d285f078cefce32"
      end
    else
      raise "rubygem-ffi version #{version} has not been configured; Cannot continue."
  end

  if platform.is_windows?
    pkg.install do
      ["#{settings[:gem_install]} ffi-#{pkg.get_version}-#{platform.architecture}-mingw32.gem"]
    end
  end
end
