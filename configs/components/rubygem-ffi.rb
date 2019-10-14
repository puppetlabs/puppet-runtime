component "rubygem-ffi" do |pkg, settings, platform|
  pkg.version '1.9.25'
  pkg.md5sum "e8923807b970643d9e356a65038769ac"

  # Windows versions of the FFI gem have custom filenames, so we overwite the
  # defaults that _base-rubygem provides here, just for Windows.
  if platform.is_windows?
    # Vanagon's `pkg.mirror` is additive, and the _base_rubygem sets the
    # non-Windows gem as the first mirror, which is incorrect. We need to unset
    # the list of mirrors before adding the Windows-appropriate ones here:
    @component.mirrors = []
    # Same for install steps:
    @component.install = []

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
      "#{settings[:gem_install]} ffi-#{pkg.get_version}-#{platform.architecture}-mingw32.gem"
    end
  end

  pkg.environment "PATH", "/opt/pl-build-tools/bin:/usr/sbin:/usr/bin"

  if platform.is_solaris?
    pkg.build_requires 'libffi6'
    pkg.build_requires 'libffi_dev'
  end

  pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}.gem"

  pkg.install do
    [
      "#{settings[:gem_install]} ffi-#{pkg.get_version}.gem"
    ]
  end
end
