component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.132.0"
  pkg.md5sum "fc1e372ee8b41c01fd55eddc016ce900"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
