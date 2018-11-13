component "ansicon" do |pkg, settings, platform|
  pkg.version '1.71'
  pkg.md5sum '0e052ad64167f6e57baebcae1b7eef42'
  pkg.url "#{settings[:buildsources_url]}/ansicon-#{pkg.get_version}.tar.gz"

  # This component should only be included on Windows
  pkg.environment "PATH", "$(cygpath -u #{settings[:gcc_bindir]}):${PATH}"
  pkg.environment "CYGWIN", settings[:cygwin]

  pkg.build do
    ["#{platform[:make]} -fmakefile.gcc"]
  end

  pkg.install_file "x64/ansicon.exe", "#{settings[:windows_tools]}/ansicon.exe"
  pkg.install_file "x64/ansi64.dll", "#{settings[:windows_tools]}/ansi64.dll"
end
