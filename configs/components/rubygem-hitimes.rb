component "rubygem-hitimes" do |pkg, settings, platform|
  pkg.version "2.0.0"
  pkg.sha256sum "0e8bc5829251bb43be3a44e5510dfd4d5cc4fae5112bf1d1b091679dd3cda947"

  instance_eval File.read('configs/components/_base-rubygem.rb')
 end
