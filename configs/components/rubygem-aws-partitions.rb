component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.334.0"
  pkg.md5sum "755ec4704e0cba52269ed4b3ff44f695"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
