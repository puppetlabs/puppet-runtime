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

  if platform.is_cross_compiled?
    pkg.environment "PATH", "/opt/csw/bin:$$PATH" if platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$$PATH" # put cross-compilation toolchains in the path

    pkg.environment "MAKE", platform[:make] if platform.is_solaris?

    ruby_api_version = settings[:ruby_version].gsub(/\.\d*$/, '.0')
    base_ruby = case platform.name
                when /solaris-10/
                  "/opt/csw/lib/ruby/2.0.0"
                else
                  "/opt/pl-build-tools/lib/ruby/2.1.0"
                end

    # solaris 10 uses ruby 2.0 which doesn't install native extensions based on architecture
    unless platform.name =~ /solaris-10/

      # weird architecture naming conventions...
      target_architecture = if platform.architecture =~ /ppc64el|ppc64le/
                              "powerpc64le"
                            else
                              platform.architecture
                            end

      pkg.build do
        [
          %(#{platform[:sed]} -i 's/Gem::Platform.local.to_s/"#{target_architecture}-linux"/' #{base_ruby}/rubygems/basic_specification.rb),
          %(#{platform[:sed]} -i 's/Gem.extension_api_version/"#{ruby_api_version}"/' #{base_ruby}/rubygems/basic_specification.rb)
        ]
      end
    end

    # make rubygems use our target rbconfig when installing gems
    sed_command = %(s|Gem.ruby|&, '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb'|)
    pkg.build do
      [
        %(#{platform[:sed]} -i "#{sed_command}" #{base_ruby}/rubygems/ext/ext_conf_builder.rb)
      ]
    end
  end

  pkg.environment 'PATH', '/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)' if platform.is_aix?
end
