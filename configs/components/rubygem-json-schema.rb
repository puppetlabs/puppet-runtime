component "rubygem-json-schema" do |pkg, settings, platform|
  pkg.version "4.0.0"
  pkg.sha256sum "a3bfe5fa1ad9771f0637a7c339a598b8b258343c49a1110988288e04f4f3b994"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
