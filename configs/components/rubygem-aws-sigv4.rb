component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.6.0"
  pkg.md5sum "a5a45f14886bbdcff038262a80dc4c75"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
