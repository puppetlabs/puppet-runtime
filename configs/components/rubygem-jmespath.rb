component "rubygem-jmespath" do |pkg, settings, platform|
  pkg.version "1.4.0"
  pkg.md5sum "16b17ebb02e229dd83138df36d6f2470"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
