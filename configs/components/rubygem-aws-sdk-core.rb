component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.131.3"
  pkg.md5sum "67f3fd87c8488736212ec7bf24de1d5b"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
