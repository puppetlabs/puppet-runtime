component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.79.0"
  pkg.md5sum "60f71df6cfcb95f22821412cffb61331"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
