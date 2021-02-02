component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.221.0"
  pkg.md5sum "fc4585aadd7a5f712f2948acbfd5be66"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
