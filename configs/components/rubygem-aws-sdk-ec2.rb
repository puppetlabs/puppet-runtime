component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.324.0"
  pkg.md5sum "17576ac32d5490455e78d1a51de0b4b6"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
