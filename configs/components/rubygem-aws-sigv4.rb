component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.5.1"
  pkg.md5sum "2d780098958551cf9ffa6f3e7f42efb4"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
