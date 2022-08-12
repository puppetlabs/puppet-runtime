component "rubygem-ffi" do |pkg, settings, platform|
  if platform.is_cross_compiled? && (platform.is_linux? || platform.is_solaris?)
    # Installing ffi >= 1.14.0 blows up horribly if we're cross compiling on Linux and Solaris.
    # This is because we're using old rubies (2.1 and 2.0) to install gems which do not have
    # methods like `append_ldflags`.
    # (see https://github.com/ffi/ffi/commit/3aa6b25f5423a64ad4afa7f2a5a5855483bae3c2)
    #
    # A more long term solution would be to update the host rubies on those
    # platforms to something newer (preferably the same API version as the ruby
    # we're building for). We can probably avoid this until we start shipping Ruby 3.
    pkg.version '1.13.1'
    pkg.sha256sum '4e15f52ee45af7c5674d656041855448adbb5022618be252cd602d81b8e2978a'
  else
    pkg.version '1.15.5'
    pkg.sha256sum '6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0'
  end

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
      # NOTE: make sure to verify the shas for the x64-mingw32 gem!
      case pkg.get_version
      when '1.9.25'
        pkg.sha256sum '5473ac958b78f271f53e9a88197c35cd3e990fbe625d21e525c56d62ae3750da'
      when '1.15.5'
        pkg.sha256sum '9acc4e474bef25dbcf827b1e6fce4067e9a1eff74a0296d25f0af392fafcd096'
      end

      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x64-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x64-mingw32.gem"
    else
      # Note make sure to verify the shas from the x86-mingw32 gem!
      case pkg.get_version
      when '1.9.25'
        pkg.sha256sum '43d357732a6a0e3e41dc7e28a9c9c5112ac66f4a6ed9e1de40afba9ffcb836c1'
      when '1.15.5'
        pkg.sha256sum '6e52c39fdbbccc085ae05d489d1b835ce05dcdf2a4c88ba739e3b42afd2b5404'
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

  if platform.is_cross_compiled_linux? || platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:/opt/csw/bin:$(PATH)"
  end

  if platform.name =~ /solaris-11-i386/
    pkg.install_file "/usr/lib/libffi.so.5.0.10", "#{settings[:libdir]}/libffi.so"
  elsif platform.name =~ /solaris-10-i386/
    pkg.install_file "/opt/csw/lib/libffi.so.6", "#{settings[:libdir]}/libffi.so.6"
  end


  pkg.environment 'PATH', '/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)' if platform.is_aix?

  if platform.is_cross_compiled? && !platform.is_macos?
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
