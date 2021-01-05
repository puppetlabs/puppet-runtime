component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.110.0"
  pkg.md5sum "2bc5a7da71c3aec59fca906eb9bbd524"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
