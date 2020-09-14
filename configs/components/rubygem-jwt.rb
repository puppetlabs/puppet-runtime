component "rubygem-jwt" do |pkg, settings, platform|
  pkg.version "2.2.2"
  pkg.md5sum "33d01d792216c68b0f964aed0858635c"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
