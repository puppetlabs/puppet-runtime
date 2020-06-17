component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.170.0"
  pkg.md5sum "013e51f41105ea8449efe02ad2afff97"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
