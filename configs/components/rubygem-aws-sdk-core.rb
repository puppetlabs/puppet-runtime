component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.119.1"
  pkg.md5sum "95cb2050f42194e3329d09720b02d0f7"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
