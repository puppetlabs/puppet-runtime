component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.9.1"
  pkg.md5sum "3b9757f618ad2c151c73462cb5061a6f"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
