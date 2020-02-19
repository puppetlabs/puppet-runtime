component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.274.0"
  pkg.md5sum "a258d84bac1e3538c0de8ec2df39c0cb"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
