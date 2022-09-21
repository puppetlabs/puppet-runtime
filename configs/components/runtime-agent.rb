# This component exists to link in the gcc and stdc++ runtime libraries as well as libssp.
component "runtime-agent" do |pkg, settings, platform|
  pkg.environment "PROJECT_SHORTNAME", "puppet"
  pkg.add_source "file://resources/files/runtime/runtime.sh"

  if platform.is_cross_compiled?
    if platform.architecture =~ /aarch64|ppc64$|ppc64le/
      libdir = File.join("/opt/pl-build-tools", settings[:platform_triple], "lib64")
    else
      libdir = File.join("/opt/pl-build-tools", settings[:platform_triple], "lib")
    end
  elsif platform.name == "aix-7.1-ppc"
    libdir = "/opt/pl-build-tools/lib/gcc/powerpc-ibm-aix7.1.0.0/5.2.0/"
  elsif platform.is_solaris? || platform.architecture =~ /i\d86/
    libdir = "/opt/pl-build-tools/lib"
  elsif platform.architecture =~ /64/
    libdir = "/opt/pl-build-tools/lib64"
  end

  # The runtime script uses readlink, which is in an odd place on Solaris systems:
  pkg.environment "PATH", "$(PATH):/opt/csw/gnu" if platform.is_solaris?

  if platform.is_aix?
    pkg.install_file File.join(libdir, "libstdc++.a"), "/opt/puppetlabs/puppet/lib/libstdc++.a"
    pkg.install_file File.join(libdir, "libgcc_s.a"), "/opt/puppetlabs/puppet/lib/libgcc_s.a"
  elsif platform.is_windows?
    lib_type = platform.architecture == "x64" ? "seh" : "sjlj"
    pkg.install_file "#{settings[:gcc_bindir]}/libgcc_s_#{lib_type}-1.dll", "#{settings[:bindir]}/libgcc_s_#{lib_type}-1.dll"
    pkg.install_file "#{settings[:gcc_bindir]}/libstdc++-6.dll", "#{settings[:bindir]}/libstdc++-6.dll"
    pkg.install_file "#{settings[:gcc_bindir]}/libwinpthread-1.dll", "#{settings[:bindir]}/libwinpthread-1.dll"
    pkg.install_file "#{settings[:gcc_bindir]}/libgcc_s_#{lib_type}-1.dll", "#{settings[:facter_root]}/lib/libgcc_s_#{lib_type}-1.dll"
    pkg.install_file "#{settings[:gcc_bindir]}/libstdc++-6.dll", "#{settings[:facter_root]}/lib/libstdc++-6.dll"
    pkg.install_file "#{settings[:gcc_bindir]}/libwinpthread-1.dll", "#{settings[:facter_root]}/lib/libwinpthread-1.dll"

    # Curl is dynamically linking against zlib, so we need to include this file until we
    # update curl to statically link against zlib
    pkg.install_file "#{settings[:tools_root]}/bin/zlib1.dll", "#{settings[:ruby_bindir]}/zlib1.dll"

    # gdbm, yaml-cpp and iconv are all runtime dependancies of ruby, and their libraries need
    # To exist inside our vendored ruby
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm-4.dll", "#{settings[:ruby_bindir]}/libgdbm-4.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm_compat-4.dll", "#{settings[:ruby_bindir]}/libgdbm_compat-4.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libiconv-2.dll", "#{settings[:ruby_bindir]}/libiconv-2.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libffi-6.dll", "#{settings[:ruby_bindir]}/libffi-6.dll"
  elsif platform.is_solaris? ||
        platform.name =~ /debian-9|el-[567]|redhatfips-7|sles-(:?11|12)|ubuntu-(:?14.04|18.04-amd64)/
    pkg.install do
      "bash runtime.sh #{libdir} puppet"
    end
  end
end
