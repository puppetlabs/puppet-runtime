component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.220.0"
  pkg.md5sum "861967dcae85ea521b75e940350e1227"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
