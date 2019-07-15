component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.188.0"
  pkg.md5sum "9814fe76b4de8158f255dd678cd3ff12"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
