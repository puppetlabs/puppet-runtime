component "rubygem-puppetfile-resolver" do |pkg, settings, platform|
  pkg.version "0.1.0"
  pkg.md5sum "5fcb2ee3525feae3863f854795a64079"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
