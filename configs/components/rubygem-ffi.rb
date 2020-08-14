component "rubygem-ffi" do |pkg, settings, platform|
  pkg.version '1.13.1'
  pkg.md5sum "569d4561359cb3c8d8360d26bd1be4ed"

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Windows versions of the FFI gem have custom filenames, so we overwite the
  # defaults that _base-rubygem provides here, just for Windows.
  if platform.is_windows?
    # Pin this if lower than Ruby 2.7
    rb_minor_version = settings[:ruby_version].split('.')[1].to_i
    pkg.version '1.9.25' if rb_minor_version < 7
    # Vanagon's `pkg.mirror` is additive, and the _base_rubygem sets the
    # non-Windows gem as the first mirror, which is incorrect. We need to unset
    # the list of mirrors before adding the Windows-appropriate ones here:
    @component.mirrors = []
    # Same for install steps:
    @component.install = []

    if platform.architecture == "x64"
      case pkg.get_version
      when '1.9.25'
        pkg.md5sum "e263997763271fba35562245b450576f"
      when '1.13.1'
        pkg.sha256sum "029c5c65c4b862a901d8751b8265f46cdcedf6f9186f59121e7511cbeb6e36be"
      end

      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x64-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x64-mingw32.gem"
    else
      case pkg.get_version
      when '1.9.25'
        pkg.md5sum "3303124f1ca0ee3e59829301ffcad886"
      when '1.13.1'
        pkg.sha256sum "10d30fca1ddeac3ca27b39c60ef408248a4714692bb22b4789da7598a9ded69e"
      end

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

  if platform.name =~ /solaris-11-i386/
    pkg.install_file "/usr/lib/libffi.so.5.0.10", "#{settings[:libdir]}/libffi.so"
  elsif platform.name =~ /solaris-10-i386/
    pkg.install_file "/opt/csw/lib/libffi.so.6", "#{settings[:libdir]}/libffi.so.6"
  end

  if platform.name =~ /el-5-x86_64/
    pkg.install_file "/usr/lib64/libffi.so.5", "#{settings[:libdir]}/libffi.so.5"
  end

  pkg.environment 'PATH', '/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)' if platform.is_aix?

  if platform.is_cross_compiled?
    base_ruby = case platform.name
                when /solaris-10/
                  "/opt/csw/lib/ruby/2.0.0"
                else
                  "/opt/pl-build-tools/lib/ruby/2.1.0"
                end

    # force compilation without system libffi in order to have a statically linked ffi_c.so
    if platform.name =~ /solaris-11-sparc/
      sed_exp = 's|CONFIG\["LDFLAGS"\].*|CONFIG["LDFLAGS"] = "-Wl,-rpath-link,/opt/pl-build-tools/sparc-sun-solaris2.11/sysroot/lib:/opt/pl-build-tools/sparc-sun-solaris2.11/sysroot/usr/lib -L. -Wl,-rpath=/opt/puppetlabs/puppet/lib -fstack-protector"|'

      pkg.configure do
        [
          # libtool always uses the system/solaris ld even if we
          # configure it to use the GNU ld, causing some flag
          # mismatches, so just temporarily move the system ld
          # somewhere else
          %(mv /usr/bin/ld /usr/bin/ld1),
          %(#{platform[:sed]} -i '#{sed_exp}' /opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb)
        ]
      end

      # move ld back after the gem is installed
      pkg.install { "mv /usr/bin/ld1 /usr/bin/ld" }
    end

    # FFI 1.13.1 forced the minimum required ruby version to ~> 2.3
    # In order to be able to install the gem using pl-ruby(2.1.9)
    # we need to remove the required ruby version check
    pkg.configure do
      %(#{platform[:sed]} -i '0,/ensure_required_ruby_version_met/b; /ensure_required_ruby_version_met/d' #{base_ruby}/rubygems/installer.rb)
    end
  end
end
