component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.259.0"
  pkg.md5sum "e93081b9c457f7efda1299e19602d794"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
