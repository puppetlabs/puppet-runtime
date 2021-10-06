component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.510.0"
  pkg.md5sum "2b6b74a39fab464fd63690f961c8c5b9"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
