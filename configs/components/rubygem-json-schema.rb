component "rubygem-json-schema" do |pkg, settings, platform|
  pkg.version "4.1.1"
  pkg.sha256sum "89a8399745a710c2c7be3ff9564f67a0ae982c82f7590a95ab9cebe374fa2d49"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
