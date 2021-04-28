component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.235.0"
  pkg.md5sum "d8e184a04c93ae7c49fed74ad36e2fd1"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
