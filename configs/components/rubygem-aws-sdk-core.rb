component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.102.0"
  pkg.md5sum "288a93975a8810d7d9d692147cf0de99"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
