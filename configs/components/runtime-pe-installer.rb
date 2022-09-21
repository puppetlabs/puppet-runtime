# This component exists to link in the gcc runtime libraries.
component "runtime-pe-installer" do |pkg, settings, platform|
  pkg.environment "PROJECT_SHORTNAME", "installer"
  
  if platform.name =~ /el-[67]|redhatfips-7|sles-12|ubuntu-18.04-amd64/
    libbase = platform.architecture =~ /64/ ? 'lib64' : 'lib'
    libdir = "/opt/pl-build-tools/#{libbase}"
    pkg.add_source "file://resources/files/runtime/runtime.sh"
    pkg.install do
      "bash runtime.sh #{libdir}"
    end
  end
end
