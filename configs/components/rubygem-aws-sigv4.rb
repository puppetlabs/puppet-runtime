component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.1.0"
  pkg.md5sum "f51d0073cbe030a489674374b24760d4"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
