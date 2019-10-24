component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.112.0"
  pkg.md5sum "d9331fcb600fd64c27d6cd5f467821c6"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
