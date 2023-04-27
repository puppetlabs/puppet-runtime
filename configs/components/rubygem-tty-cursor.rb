component "rubygem-tty-cursor" do |pkg, settings, platform|
  pkg.version "0.7.1"
  pkg.sha256sum "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
