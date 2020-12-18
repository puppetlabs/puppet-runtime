# This component exists to link in the gcc and stdc++ runtime libraries.
component "runtime-pdk" do |pkg, settings, platform|
  if platform.is_windows?
    lib_type = platform.architecture == "x64" ? "seh" : "sjlj"
    ["libgcc_s_#{lib_type}-1.dll", 'libstdc++-6.dll', 'libwinpthread-1.dll'].each do |dll|
      pkg.install_file File.join(settings[:gcc_bindir], dll), File.join(settings[:bindir], dll)
    end

    # Ruby needs zlib
    pkg.build_requires "pl-zlib-#{platform.architecture}"
    pkg.install_file "#{settings[:tools_root]}/bin/zlib1.dll", "#{settings[:bindir]}/zlib1.dll"

    # zlib, gdbm, yaml-cpp and iconv are all runtime dependancies of ruby, and their libraries need
    # To exist inside our vendored ruby
    pkg.install_file "#{settings[:tools_root]}/bin/zlib1.dll", "#{settings[:ruby_bindir]}/zlib1.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm-4.dll", "#{settings[:ruby_bindir]}/libgdbm-4.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm_compat-4.dll", "#{settings[:ruby_bindir]}/libgdbm_compat-4.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libiconv-2.dll", "#{settings[:ruby_bindir]}/libiconv-2.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libffi-6.dll", "#{settings[:ruby_bindir]}/libffi-6.dll"

    # Copy the DLLs into additional ruby install bindirs as well.
    if settings.has_key?(:additional_rubies)
      settings[:additional_rubies].each do |rubyver, local_settings|
        pkg.install_file "#{settings[:tools_root]}/bin/zlib1.dll", "#{local_settings[:ruby_bindir]}/zlib1.dll"
        pkg.install_file "#{settings[:tools_root]}/bin/libgdbm-4.dll", "#{local_settings[:ruby_bindir]}/libgdbm-4.dll"
        pkg.install_file "#{settings[:tools_root]}/bin/libgdbm_compat-4.dll", "#{local_settings[:ruby_bindir]}/libgdbm_compat-4.dll"
        pkg.install_file "#{settings[:tools_root]}/bin/libiconv-2.dll", "#{local_settings[:ruby_bindir]}/libiconv-2.dll"
        pkg.install_file "#{settings[:tools_root]}/bin/libffi-6.dll", "#{local_settings[:ruby_bindir]}/libffi-6.dll"
      end
    end
  elsif platform.is_macos?

    # Do nothing

  else # Linux and Solaris systems
    if platform.is_fedora? && platform.os_version.to_i >= 29 ||
        (platform.is_el? && platform.os_version.to_i >= 8) ||
        (platform.is_debian? && platform.os_version.to_i >= 10) ||
        (platform.is_ubuntu? && platform.os_version.split('.').first.to_i >= 20)
      # On newer linux platforms we are no longer using the pl-build-tools
      # package and instead relying on standard distribution versions of
      # gcc, etc.
      libdir = "/usr/lib64"
    else
      libdir = "/opt/pl-build-tools/lib64"
    end

    pkg.add_source "file://resources/files/runtime/runtime.sh"
    pkg.install do
      "bash runtime.sh #{libdir}"
    end
  end
end
