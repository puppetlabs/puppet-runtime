component 'rubygem-win32-eventlog' do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version '0.6.2'
  pkg.md5sum '89b2e7dd8cc599168fa444e73c014c3d'
  pkg.url "https://rubygems.org/downloads/win32-eventlog-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/win32-eventlog-#{pkg.get_version}.gem"


  pkg.install do
    ["#{settings[:gem_install]} win32-eventlog-#{pkg.get_version}.gem"]
  end
end
