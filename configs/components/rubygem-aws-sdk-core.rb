component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.170.0"
  pkg.md5sum "0c8b3c6bda23b265c2aa09b7212326bb"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
