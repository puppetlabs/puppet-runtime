component 'rubygem-optimist' do |pkg, settings, _platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version '3.0.0'
  pkg.md5sum '85785b247885704e61230b0c024f494c'
  pkg.url "https://rubygems.org/downloads/optimist-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/optimist-#{pkg.get_version}.gem"

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])

  pkg.install do
    ["#{settings[:gem_install]} optimist-#{pkg.get_version}.gem"]
  end
end
