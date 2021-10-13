component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.514.0"
  pkg.md5sum "295dca1f9ebdfc2b0217b21f1be1c59e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
