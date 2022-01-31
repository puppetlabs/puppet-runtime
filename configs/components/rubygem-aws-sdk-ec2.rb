component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.288.0"
  pkg.md5sum "e61dd70c293188270997ecf0f14c584d"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
