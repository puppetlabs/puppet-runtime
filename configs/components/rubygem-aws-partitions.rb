component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.270.0"
  pkg.md5sum "96dcfe8e93bf3c7ae1c149c16c9af10d"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
