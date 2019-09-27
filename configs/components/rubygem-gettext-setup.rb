component "rubygem-gettext-setup" do |pkg, settings, platform|
  pkg.version "0.31"
  pkg.md5sum "529706bf23b9c796d1ccad790764c41e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
