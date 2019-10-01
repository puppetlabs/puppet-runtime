component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.219.0"
  pkg.md5sum "dc5bd41a0e798c28f918384a18c128b4"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
