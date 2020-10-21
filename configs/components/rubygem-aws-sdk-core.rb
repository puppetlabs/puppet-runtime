component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.109.1"
  pkg.md5sum "eb390bf65b5e6f50c449453c0d56a4f7"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
