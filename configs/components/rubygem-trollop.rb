component "rubygem-trollop" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version '2.1.2'
  pkg.md5sum '6ff25bc7f93497c107b67f9ae5bf73b4'
  pkg.url "https://rubygems.org/downloads/trollop-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/trollop-#{pkg.get_version}.gem"

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver:
  pkg.environment "GEM_HOME", settings[:puppet_gem_vendor_dir]

  pkg.install do
    ["#{settings[:gem_install]} trollop-#{pkg.get_version}.gem"]
  end
end
