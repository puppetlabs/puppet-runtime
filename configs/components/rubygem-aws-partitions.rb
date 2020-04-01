component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.292.0"
  pkg.md5sum "e5d1428f47d35c01fe2023a14c189f45"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
