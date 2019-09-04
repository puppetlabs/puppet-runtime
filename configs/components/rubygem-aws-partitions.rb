component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.207.0"
  pkg.md5sum "d873c7bd28ee46abc9c99e8dc6a37a9e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
