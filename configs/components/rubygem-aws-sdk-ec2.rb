component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.481.0"
  pkg.md5sum "bbe900b317e117849d7a440dd1f1e12b"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
