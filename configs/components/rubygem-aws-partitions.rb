component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.414.0"
  pkg.md5sum "22852d399b0ee81533b67dc3ca8c0b9b"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
