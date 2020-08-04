component "rubygem-ffi" do |pkg, settings, platform|
  pkg.version '1.13.1'
  pkg.md5sum "569d4561359cb3c8d8360d26bd1be4ed"

  instance_eval File.read('configs/components/_base-rubygem.rb')

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
      pkg.sha256sum "029c5c65c4b862a901d8751b8265f46cdcedf6f9186f59121e7511cbeb6e36be"
      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x64-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x64-mingw32.gem"
    else
      pkg.sha256sum "10d30fca1ddeac3ca27b39c60ef408248a4714692bb22b4789da7598a9ded69e"
      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x86-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x86-mingw32.gem"
    end

    pkg.install do
      "#{settings[:gem_install]} ffi-#{pkg.get_version}-#{platform.architecture}-mingw32.gem"
    end
  end

  # due to contrib/make_sunver.pl missing on solaris 11 we cannot compile libffi, so we provide the opencsw library
  pkg.environment "CPATH", "/opt/csw/lib/libffi-3.2.1/include" if platform.name =~ /solaris-11/
  pkg.environment "MAKE", platform[:make] if platform.is_solaris?

  if platform.is_cross_compiled? || platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:/opt/csw/bin:$$PATH"
  end

  if platform.name =~ /solaris-11-sparc/
    pkg.install_file "#{settings[:tools_root]}/#{settings[:platform_triple]}/sysroot/usr/lib/libffi.so.5.0.10", "#{settings[:libdir]}/libffi.so"
  elsif platform.name =~ /solaris-11-i386/
    pkg.install_file "/usr/lib/libffi.so.5.0.10", "#{settings[:libdir]}/libffi.so"
  elsif platform.name =~ /solaris-10-i386/
    pkg.install_file "/opt/csw/lib/libffi.so.6", "#{settings[:libdir]}/libffi.so.6"
  end

  if platform.name =~ /el-5-x86_64/
    pkg.install_file "/usr/lib64/libffi.so.5", "#{settings[:libdir]}/libffi.so.5"
  end

  pkg.environment 'PATH', '/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)' if platform.is_aix?

  # FFI 1.13.1 forced the minimum required ruby version to ~> 2.3
  # In order to be able to install the gem using pl-ruby(2.1.9)
  # we need to remove the required ruby version check
  if platform.is_cross_compiled?
    base_ruby = case platform.name
                when /solaris-10/
                  "/opt/csw/lib/ruby/2.0.0"
                else
                  "/opt/pl-build-tools/lib/ruby/2.1.0"
                end

    pkg.configure do
      %(#{platform[:sed]} -i '0,/ensure_required_ruby_version_met/b; /ensure_required_ruby_version_met/d' #{base_ruby}/rubygems/installer.rb)
    end
  end
end
