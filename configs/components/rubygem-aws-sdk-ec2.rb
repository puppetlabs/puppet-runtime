component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.245.0"
  pkg.md5sum "55d03fecb2bbd058f40b931828227f43"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
