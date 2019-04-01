# This component exists to link in the gcc runtime libraries.
component "runtime-pe-installer" do |pkg, settings, platform|
  pkg.environment "PROJECT_SHORTNAME", "installer"

  if platform.is_windows?
    lib_type = platform.architecture == "x64" ? "seh" : "sjlj"
    pkg.install_file "#{settings[:gcc_bindir]}/libgcc_s_#{lib_type}-1.dll", "#{settings[:bindir]}/libgcc_s_#{lib_type}-1.dll"

    # zlib, gdbm, yaml-cpp and iconv are all runtime dependancies of ruby, and their libraries need to exist inside our vendored ruby
    pkg.build_requires "pl-zlib-#{platform.architecture}"
    pkg.install_file "#{settings[:tools_root]}/bin/zlib1.dll", "#{settings[:ruby_bindir]}/zlib1.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm-4.dll", "#{settings[:ruby_bindir]}/libgdbm-4.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm_compat-4.dll", "#{settings[:ruby_bindir]}/libgdbm_compat-4.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libiconv-2.dll", "#{settings[:ruby_bindir]}/libiconv-2.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libffi-6.dll", "#{settings[:ruby_bindir]}/libffi-6.dll"
  elsif platform.is_macos?

    # Do nothing

  else # Linux and Solaris systems
    libbase = platform.architecture =~ /64/ ? 'lib64' : 'lib'
    if platform.name =~ /el-8/
      libdir = "/usr/#{libbase}"
    else
      libdir = "/opt/pl-build-tools/#{libbase}"
    end
    pkg.add_source "file://resources/files/runtime/runtime.sh"
    pkg.install do
      "bash runtime.sh #{libdir}"
    end
  end
end
