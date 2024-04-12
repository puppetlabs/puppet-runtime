component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.8.0"
  pkg.md5sum "586f3e0e914c67bae0b8793e64347c03"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
