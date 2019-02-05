component "rubygem-minitar" do |pkg, settings, platform|
  # Projects may define a :rubygem_minitar_version setting, or we use 0.6.1 by default:
  version = settings[:rubygem_minitar_version] || '0.6.1'
  pkg.version version

  case version
  when "0.6.1"
    pkg.md5sum "ce4ee63a94e80fb4e3e66b54b995beaa"
  when "0.8"
    pkg.md5sum "af220249c7dfe1774de3a81da4bb21d7"
  else
    raise "rubygem-minitar version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.url "https://rubygems.org/downloads/minitar-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/minitar-#{pkg.get_version}.gem"

  pkg.install do
    ["#{settings[:gem_install]} minitar-#{pkg.get_version}.gem"]
  end
end
