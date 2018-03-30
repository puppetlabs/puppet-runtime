component "rubygem-multi_json" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version '1.13.1'
  pkg.md5sum 'b7702a827fd011461fbda6b80f2219d5'
  pkg.url "https://rubygems.org/downloads/multi_json-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/multi_json-#{pkg.get_version}.gem"

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver:
  pkg.environment "GEM_HOME", settings[:puppet_gem_vendor_dir]

  pkg.install do
    ["#{settings[:gem_install]} multi_json-#{pkg.get_version}.gem"]
  end
end
