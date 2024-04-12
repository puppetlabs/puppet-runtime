component "rubygem-addressable" do |pkg, settings, platform|
  pkg.version "2.8.6"
  pkg.sha256sum "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
