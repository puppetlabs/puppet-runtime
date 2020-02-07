component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.138.0"
  pkg.md5sum "399060bb0ced2ef39acf5982c68bec83"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
