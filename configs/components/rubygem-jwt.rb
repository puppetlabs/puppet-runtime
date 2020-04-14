component "rubygem-jwt" do |pkg, settings, platform|
  pkg.version "2.2.1"
  pkg.md5sum "d1ac787acb10288b931bddcfe361f61e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
