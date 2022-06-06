component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.131.1"
  pkg.md5sum "4c9fc65a85ca5d7834ef0570754f9503"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
