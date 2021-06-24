component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.114.1"
  pkg.md5sum "6769e3bd1749592b9ce817ef13c0b8c9"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
