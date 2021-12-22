component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.125.0"
  pkg.md5sum "da5a17133b9b7d3aa4d86895488e7c45"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
