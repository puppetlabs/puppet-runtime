component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.111.2"
  pkg.md5sum "29f45906de1a73ef703e30aa7e2cc22b"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
