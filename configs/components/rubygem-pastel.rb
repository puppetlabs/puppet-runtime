component "rubygem-pastel" do |pkg, settings, platform|
  pkg.version "0.8.0"
  pkg.sha256sum '481da9fb7d2f6e6b1a08faf11fa10363172dc40fd47848f096ae21209f805a75'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
