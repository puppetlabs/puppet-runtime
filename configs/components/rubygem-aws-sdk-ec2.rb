component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.106.0"
  pkg.md5sum "4fc8e5bd09e37505f0ecfb354a07fe69"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
