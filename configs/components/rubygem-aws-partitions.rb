component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.407.0"
  pkg.md5sum "399af7454f62196c4cedb56871aaa9bf"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
