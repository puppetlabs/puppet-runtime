component "rubygem-minitar" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "0.6.1"
  pkg.md5sum "ce4ee63a94e80fb4e3e66b54b995beaa"
  pkg.url "https://rubygems.org/downloads/minitar-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/minitar-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} minitar-#{pkg.get_version}.gem"]
  end
end
