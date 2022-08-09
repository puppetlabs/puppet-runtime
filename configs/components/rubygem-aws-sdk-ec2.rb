component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.326.0"
  pkg.md5sum "6a50657e534e0bd3dabe8829f8329320"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
