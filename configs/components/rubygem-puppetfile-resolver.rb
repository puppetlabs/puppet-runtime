component "rubygem-puppetfile-resolver" do |pkg, settings, platform|
  pkg.version "0.6.2"
  pkg.md5sum "e0b40ef4258d32d6d47857b1eb4a5acf"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
