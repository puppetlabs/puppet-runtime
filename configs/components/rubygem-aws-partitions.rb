component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.196.0"
  pkg.md5sum "34fc289cf533f40b719d696b55c146e5"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
