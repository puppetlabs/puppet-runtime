component "rubygem-pkg-config" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "1.1.7"
  pkg.md5sum "2767d4620b32f2a4ccddc18c353e5385"
  pkg.url "https://rubygems.org/downloads/pkg-config-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/pkg-config-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} pkg-config-#{pkg.get_version}.gem"]
  end
end
