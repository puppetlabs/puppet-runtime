component "rubygem-httpclient" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version "2.8.3"
  pkg.md5sum "0d43c4680b56547b942caa0d9fefa8ec"
  pkg.url "https://rubygems.org/downloads/httpclient-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/httpclient-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} httpclient-#{pkg.get_version}.gem"]
  end
end
