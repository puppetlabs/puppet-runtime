component "rubygem-puppetfile-resolver" do |pkg, settings, platform|
  pkg.version "0.6.3"
  pkg.md5sum "8377387749cf0fcfcfd9f8c0c6baaf0c"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
