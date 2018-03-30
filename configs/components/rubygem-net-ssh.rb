component "rubygem-net-ssh" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "4.1.0"
  pkg.md5sum "6af1ff8c42a07b11203058c9b74cbaef"
  pkg.url "https://rubygems.org/downloads/net-ssh-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/net-ssh-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} net-ssh-#{pkg.get_version}.gem"]
  end
end
