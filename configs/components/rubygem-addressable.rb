component "rubygem-addressable" do |pkg, settings, platform|
  pkg.version "2.8.7"
  pkg.sha256sum "462986537cf3735ab5f3c0f557f14155d778f4b43ea4f485a9deb9c8f7c58232"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
