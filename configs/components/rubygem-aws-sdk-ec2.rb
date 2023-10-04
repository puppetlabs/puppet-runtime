component "rubygem-aws-sdk-ec2" do |pkg, settings, platform|
  pkg.version "1.411.0"
  pkg.md5sum "1f915f9bb6344d054a29c17478789460"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
