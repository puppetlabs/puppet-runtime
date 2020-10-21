component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.384.0"
  pkg.md5sum "45ade28fae48cb47868d9de0676f1e15"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
