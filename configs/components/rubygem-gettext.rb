component "rubygem-gettext" do |pkg, settings, platform|
  pkg.version "3.2.2"
  pkg.md5sum "4cbb125f8d8206e9a8f3a90f6488e4da"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
