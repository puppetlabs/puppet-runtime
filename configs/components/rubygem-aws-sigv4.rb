component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.2.4"
  pkg.md5sum "dc1674c1675fea2b561433e3632c3be5"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
