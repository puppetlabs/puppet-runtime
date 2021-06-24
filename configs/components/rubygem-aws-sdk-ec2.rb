component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.240.0"
  pkg.md5sum "9e2797eb4cac551c5c15fab8038a53d5"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
