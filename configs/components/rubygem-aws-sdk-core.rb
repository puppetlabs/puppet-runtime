component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.92.0"
  pkg.md5sum "118c7a146f65f09122c20601b4d12892"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
