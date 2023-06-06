component "rubygem-wisper" do |pkg, settings, platform|
  pkg.version "2.0.1"
  pkg.sha256sum "ce17bc5c3a166f241a2e6613848b025c8146fce2defba505920c1d1f3f88fae6"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
