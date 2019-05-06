component "rubygem-hocon" do |pkg, settings, platform|
  pkg.version "1.2.5"
  pkg.md5sum "e7821d3a731ab617320ccfa4f67f886b"

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])

  # Special case for macOS:
  if platform.is_macos?
    # The normal installation step from the _base_rubygem component works fine
    # here, but the unicode characters in one of the hocon gem's spec files
    # will make tar blow up when extracting the runtime tarball on macOS if not
    # using unicode. We don't need the spec files anyway, so remove them
    # (note pkg.install is additive, so we're adding this command after the
    # usual install step from _base_rubygem):
    pkg.install do
      "rm -rf #{settings[:gem_home]}/gems/hocon-#{pkg.get_version}/spec"
    end
  end
end
