component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.117.0"
  pkg.md5sum "8eda3faf8c4a91d5f84a781cb92aafbd"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
