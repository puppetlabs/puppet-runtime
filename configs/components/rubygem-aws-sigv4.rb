component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.10.0"
  pkg.md5sum "f9875621945414c4ee48113a3cb7076e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
