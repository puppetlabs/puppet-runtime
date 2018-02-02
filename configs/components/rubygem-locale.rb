component "rubygem-locale" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "2.1.2"
  pkg.md5sum "def1e89d1d3126a0c684d3b7b20d88d4"
  pkg.url "https://rubygems.org/downloads/locale-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/locale-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} locale-#{pkg.get_version}.gem"]
  end
end
