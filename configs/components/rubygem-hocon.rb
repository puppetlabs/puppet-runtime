component "rubygem-hocon" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "1.2.5"
  pkg.md5sum "e7821d3a731ab617320ccfa4f67f886b"
  pkg.url "https://rubygems.org/downloads/hocon-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/hocon-#{pkg.get_version}.gem"

  install_steps = ["#{settings[:gem_install]} hocon-#{pkg.get_version}.gem"]

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])

  if platform.is_macos?
    # The unicode characters in one of the hocon gem's spec files will make tar
    # blow up when extracting the runtime tarball on MacOS if not using unicode.
    # We don't need the spec files anyway, so remove them:
    install_steps << "rm -rf #{settings[:gem_home]}/gems/hocon-#{pkg.get_version}/spec"
  end

  pkg.install do
    install_steps
  end
end
