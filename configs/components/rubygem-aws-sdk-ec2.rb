component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.269.0"
  pkg.md5sum "e6c7d2dff829193048872555219e2665"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
