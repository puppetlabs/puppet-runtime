component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.151.0"
  pkg.md5sum "1344705f32bb9f1f19f4fb068a10ad61"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
