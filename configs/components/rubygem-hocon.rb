component "rubygem-hocon" do |pkg, settings, platform|
  pkg.version "1.2.6"
  pkg.md5sum "938b38e4029f024745cc9767ff0d94f4"

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
