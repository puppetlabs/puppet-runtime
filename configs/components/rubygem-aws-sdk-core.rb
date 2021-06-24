component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.115.0"
  pkg.md5sum "7a95ddd58115f245452dd2b11e5aea2f"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
