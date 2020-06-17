component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.2.1"
  pkg.md5sum "28b179833defb01be1da401694d741f0"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
