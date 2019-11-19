component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.241.0"
  pkg.md5sum "b2c106add516760c31de9c805a5fe6c5"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
