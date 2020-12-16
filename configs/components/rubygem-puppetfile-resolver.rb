component "rubygem-puppetfile-resolver" do |pkg, settings, platform|
  pkg.version "0.4.0"
  pkg.md5sum "6e0e4152b1b3012a075fbd5ccc81c5fa"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
