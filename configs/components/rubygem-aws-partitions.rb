component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.226.0"
  pkg.md5sum "a8f0698cf66e21772b55da21e2712e72"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
