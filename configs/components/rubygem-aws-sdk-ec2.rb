component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.225.0"
  pkg.md5sum "d8f4d0dffd229a5cc9b2af127d8a6039"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
