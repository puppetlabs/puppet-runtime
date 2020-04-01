component "rubygem-gettext-setup" do |pkg, settings, platform|
  pkg.version "0.34"
  pkg.md5sum "72e511431d138a7c3e062d5e06989a40"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
