component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.102.0"
  pkg.md5sum "5c482b52f66c40dbf42f3266a3c3f4b4"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
