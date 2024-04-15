component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.913.0"
  pkg.md5sum "6231fd992c84e56941488776aa0be8b5"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
