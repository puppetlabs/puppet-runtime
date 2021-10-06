component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.266.0"
  pkg.md5sum "34b730c219852e2e20a0388fcf7615ba"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
