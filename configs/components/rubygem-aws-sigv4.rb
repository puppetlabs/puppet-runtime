component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.1.1"
  pkg.md5sum "516d8371db693d375dcdc57e862aa930"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
