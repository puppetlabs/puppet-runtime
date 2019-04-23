component "rubygem-win32-dir" do |pkg, settings, platform|
  pkg.version "0.4.9"
  pkg.md5sum "df14aa01bd6011f4b6332a05e15b7fb8"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
