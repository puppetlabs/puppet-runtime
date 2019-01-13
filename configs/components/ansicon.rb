component "ansicon" do |pkg, settings, platform|
  pkg.version '1.86'
  pkg.md5sum 'f2e822dc4ad69959d61b6e09d0a56a30'
  pkg.url "#{settings[:buildsources_url]}/ansicon-#{pkg.get_version}.tar.gz"

  # This component should only be included on Windows
  pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
  pkg.environment "CYGWIN", settings[:cygwin]

  pkg.build do
    ["#{platform[:make]} -fmakefile.gcc"]
  end

  pkg.install_file "x64/ansicon.exe", "#{settings[:windows_tools]}/ansicon.exe"
  pkg.install_file "x64/ansi64.dll", "#{settings[:windows_tools]}/ansi64.dll"
end
