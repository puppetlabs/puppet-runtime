component "rubygem-net-ssh" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "4.2.0"
  pkg.md5sum "fec5b151d84110b95ec0056017804491"
  pkg.url "https://rubygems.org/downloads/net-ssh-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/net-ssh-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} net-ssh-#{pkg.get_version}.gem"]
  end
end
