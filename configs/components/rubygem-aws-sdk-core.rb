component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.114.0"
  pkg.md5sum "a53e675090a4d274fd7f7db922e66db6"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
