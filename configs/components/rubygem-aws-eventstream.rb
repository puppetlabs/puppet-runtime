component "rubygem-aws-eventstream" do |pkg, settings, platform|
  pkg.version "1.0.3"
  pkg.md5sum "cf77589b3608786511a827d402c8a260"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
