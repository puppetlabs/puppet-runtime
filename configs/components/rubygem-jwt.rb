component "rubygem-jwt" do |pkg, settings, platform|
  pkg.version "2.2.3"
  pkg.md5sum "a25cbd9b40f8da7a40faad7a26b8153c"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
