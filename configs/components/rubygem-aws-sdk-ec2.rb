component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.110.0"
  pkg.md5sum "2fb425679f899925688356cef3deddbe"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
