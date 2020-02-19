component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.144.0"
  pkg.md5sum "e0ddd0df7d44c738c62294561a325222"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
