component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.200.0"
  pkg.md5sum "aa43bad9703c309cb269707813c87068"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
