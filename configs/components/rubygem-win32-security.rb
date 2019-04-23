component "rubygem-win32-security" do |pkg, settings, platform|
  pkg.version "0.2.5"
  pkg.md5sum "97c4b971ea19ca48cea7dec1d21d506a"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
