component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.469.0"
  pkg.md5sum "e9aac12389dbd547207f662cb1b1f05b"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
