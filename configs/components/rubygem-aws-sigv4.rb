component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.2.3"
  pkg.md5sum "31f1b1fdf70e5f63a143a42b04747088"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
