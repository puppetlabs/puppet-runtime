component "rubygem-win32-service" do |pkg, settings, platform|
  pkg.version "0.8.8"
  pkg.md5sum "24cc05fed398eb931e14b8ee22196634"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
