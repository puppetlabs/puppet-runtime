component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.195.0"
  pkg.md5sum "fa2ccc15cb5d1ccb615ea4631b9c19b6"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
