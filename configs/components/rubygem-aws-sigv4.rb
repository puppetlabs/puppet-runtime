component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.4.0"
  pkg.md5sum "addb440cc9427db9ddb6ede8519a3758"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
