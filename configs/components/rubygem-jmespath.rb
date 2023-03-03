component "rubygem-jmespath" do |pkg, settings, platform|
  pkg.version "1.6.2"
  pkg.md5sum "fdd62edafbd40171f976a53ab349ae9e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
