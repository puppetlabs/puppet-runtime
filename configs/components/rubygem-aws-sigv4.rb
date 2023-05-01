component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.5.2"
  pkg.md5sum "ade83c69138704ccf1a4f765f9926985"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
