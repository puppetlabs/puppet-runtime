component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.367.0"
  pkg.md5sum "71b2517cb4d8c3c05a5597ba6424b7a2"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
