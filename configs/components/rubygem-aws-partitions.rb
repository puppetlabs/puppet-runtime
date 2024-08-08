component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.962.0"
  pkg.md5sum "41189f42dc83691fdfa8153e4dbf988d"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
