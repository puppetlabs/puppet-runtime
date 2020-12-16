component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.217.0"
  pkg.md5sum "77ddef9c41d754a2887e26df096dea67"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
