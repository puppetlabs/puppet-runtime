component "rubygem-jwt" do |pkg, settings, platform|
  pkg.version "2.7.1"
  pkg.md5sum "d3a7ba14444b03f91c7d36b61519fe17"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
