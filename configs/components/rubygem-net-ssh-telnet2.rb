component "rubygem-net-ssh-telnet2" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "0.1.1"
  pkg.md5sum "8fba7aada691a0c10caf5b74f57cfef2"
  pkg.url "https://rubygems.org/downloads/net-ssh-telnet2-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/net-ssh-telnet2-#{pkg.get_version}.gem"

  pkg.build_requires "ruby"

  pkg.install do
    ["#{settings[:gem_install]} net-ssh-telnet2-#{pkg.get_version}.gem"]
  end
end
