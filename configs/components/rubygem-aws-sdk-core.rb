component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.121.1"
  pkg.md5sum "bb6b99401878fb7471e4b8b435ee0c32"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
