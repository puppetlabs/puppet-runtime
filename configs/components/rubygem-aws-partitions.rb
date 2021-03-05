component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.431.0"
  pkg.md5sum "cf93d88a599ea7ab48eeb5fb4dcb9f62"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
