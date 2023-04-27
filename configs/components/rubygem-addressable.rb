component "rubygem-addressable" do |pkg, settings, platform|
  pkg.version "2.8.1"
  pkg.sha256sum "bc724a176ef02118c8a3ed6b5c04c39cf59209607ffcce77b91d0261dbadedfa"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
