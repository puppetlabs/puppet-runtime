component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.610.0"
  pkg.md5sum "c5deccab37d249a3cabc49a877e54185"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
