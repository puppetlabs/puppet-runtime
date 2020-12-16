component "rubygem-puppetfile-resolver" do |pkg, settings, platform|
  pkg.version "0.5.0"
  pkg.md5sum "bcfc87be63178498b6c3a9b706d0caa7"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
