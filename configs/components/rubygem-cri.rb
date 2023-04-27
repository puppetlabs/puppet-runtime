component "rubygem-cri" do |pkg, settings, platform|
  pkg.version "2.15.11"
  pkg.sha256sum "254320ef42198cf2670b36dbdd67aa8f8c177e7f058ce176f995a4ada47d1aae"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
