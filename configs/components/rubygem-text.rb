component "rubygem-text" do |pkg, settings, platform|
  pkg.version "1.3.1"
  pkg.md5sum "514c3d1db7a955fe793fc0cb149c164f"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
