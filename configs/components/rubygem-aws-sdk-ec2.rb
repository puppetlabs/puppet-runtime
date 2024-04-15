component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.448.0"
  pkg.md5sum "79f7f0f2fd051cedda210399d45590c6"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
