component "rubygem-json-schema" do |pkg, settings, platform|
  pkg.version "4.3.1"
  pkg.sha256sum "d5e68dc32b94408d0b06ad04f9382ccbb6fe5a44910e066f8547f56c471a7825"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
