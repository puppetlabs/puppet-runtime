component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.99.0"
  pkg.md5sum "f4803000aa22776db7cfb4692cc595f8"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
