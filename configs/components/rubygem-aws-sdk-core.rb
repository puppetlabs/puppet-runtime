component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.185.0"
  pkg.md5sum "834895779a8bc78112f26492688c8295"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
