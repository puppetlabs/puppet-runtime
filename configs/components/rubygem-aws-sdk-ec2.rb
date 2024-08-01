component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.467.0"
  pkg.md5sum "4b8f90993610214036a661e2ed9506ac"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
