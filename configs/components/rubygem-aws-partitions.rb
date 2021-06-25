component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.470.0"
  pkg.md5sum "364c2925fbaa664be7db168f0e935eb4"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
