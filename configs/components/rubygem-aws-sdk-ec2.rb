component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.317.0"
  pkg.md5sum "013690c04b09136840a37db608ce9a7c"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
