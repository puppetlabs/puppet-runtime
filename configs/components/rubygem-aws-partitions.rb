component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.447.0"
  pkg.md5sum "5f79bd97f319761f41ff0c15ba566f55"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
