component "rubygem-ffi" do |pkg, settings, platform|
  pkg.version '1.9.25'
  pkg.md5sum "e8923807b970643d9e356a65038769ac"

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

  if platform.is_solaris? || platform.name =~ /ubuntu-16.04-ppc64el/
    base_ruby = case platform.os_version
                when "10"
                  "/opt/csw/lib/ruby/2.0.0"
                else
                  "/opt/pl-build-tools/lib/ruby/2.1.0"
                end

    ffi_lib_version = case platform.os_version
                      when "10"
                        "6.0.4"
                      when "11"
                        "5.0.10"
                      end

    pkg.environment "PATH", "/opt/pl-build-tools/bin:/opt/csw/bin:$$PATH"

    case platform.os_version
    when "10"
      pkg.install_file "/opt/csw/lib/libffi.so.#{ffi_lib_version}", "#{settings[:libdir]}/libffi.so.6"
    when "11"
      pkg.environment "CPATH", "/opt/csw/lib/libffi-3.2.1/include"
      pkg.environment "MAKE", platform[:make]

      if platform.is_cross_compiled?
        # install libffi.so from pl-build-tools
        pkg.install_file "#{settings[:tools_root]}/#{settings[:platform_triple]}/sysroot/usr/lib/libffi.so.#{ffi_lib_version}", "#{settings[:libdir]}/libffi.so"

        # monkey-patch rubygems to think we're running on the destination ruby and architecture
        ruby_api_version = settings[:ruby_version].gsub(/\.\d*$/, '.0')
        pkg.build do
          [
            %(#{platform[:sed]} -i 's/Gem::Platform.local.to_s/&.gsub("x86", "#{platform.architecture}")/g' #{base_ruby}/rubygems/basic_specification.rb),
            %(#{platform[:sed]} -i 's/Gem.extension_api_version/"#{ruby_api_version}"/g' #{base_ruby}/rubygems/basic_specification.rb)
          ]
        end
      else
        # install system libffi.so if we're not cross compiling
        pkg.install_file "/usr/lib/libffi.so.#{ffi_lib_version}", "#{settings[:libdir]}/libffi.so"
      end
    end

    if platform.is_cross_compiled?
      # monkey-patch rubygems to require our custom rbconfig when
      # building gems with native extensions
      sed_command = %(s|Gem.ruby|&, '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb'|)
      pkg.build do
        [
          %(#{platform[:sed]} -i "#{sed_command}" #{base_ruby}/rubygems/ext/ext_conf_builder.rb)
        ]
      end
    end
  end


  pkg.environment 'PATH', '/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)' if platform.is_aix?
end
