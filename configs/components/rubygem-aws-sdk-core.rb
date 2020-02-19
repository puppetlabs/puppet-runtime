component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.90.1"
  pkg.md5sum "213c66e288aa97b209b5ec53f9f28c11"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
