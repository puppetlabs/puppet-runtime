component "rubygem-tty-spinner" do |pkg, settings, platform|
  pkg.version "0.9.3"
  pkg.sha256sum "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
